import Dependencies
import Foundation

public struct RecordLookupClient: Sendable {
  public var lookup: @Sendable (_ barcode: String) async throws -> AddRecordFeature.Record

  public init(_ lookup: @escaping @Sendable (_ barcode: String) async throws -> AddRecordFeature.Record) {
    self.lookup = lookup
  }
}

extension RecordLookupClient: DependencyKey {
  public static let liveValue = Self { barcode in
    try await RecordLookupService().lookup(barcode: barcode)
  }

  public static let testValue = Self(unimplemented("RecordLookupClient.lookup"))
}

public enum RecordLookupClientError: Error, Equatable {
  case invalidResponse
  case notFound
  case notImplemented
}

public extension DependencyValues {
  var recordLookupClient: RecordLookupClient {
    get { self[RecordLookupClient.self] }
    set { self[RecordLookupClient.self] = newValue }
  }
}

struct RecordLookupService {
  private let urlSession: URLSession
  private let userAgent: String

  init(urlSession: URLSession = .shared, userAgent: String = Self.defaultUserAgent) {
    self.urlSession = urlSession
    self.userAgent = userAgent
  }

  func lookup(barcode: String) async throws -> AddRecordFeature.Record {
    if let record = try await lookupMusicBrainz(barcode: barcode) {
      return record
    }

    throw RecordLookupClientError.notFound
  }

  private func lookupMusicBrainz(barcode: String) async throws -> AddRecordFeature.Record? {
    guard let url = musicBrainzSearchURL(barcode: barcode) else {
      throw RecordLookupClientError.invalidResponse
    }

    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

    let (data, response) = try await urlSession.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw RecordLookupClientError.invalidResponse
    }

    let payload = try JSONDecoder().decode(MusicBrainzSearchResponse.self, from: data)
    guard let release = payload.releases.first,
          let artist = release.artistCredit.displayName,
          !artist.isEmpty
    else {
      return nil
    }

    let coverURL = await coverArtURL(releaseID: release.id)
    return AddRecordFeature.Record(title: release.title, artist: artist, coverURL: coverURL)
  }

  private func coverArtURL(releaseID: String) async -> URL? {
    guard let url = URL(string: "https://coverartarchive.org/release/\(releaseID)/front") else {
      return nil
    }

    var request = URLRequest(url: url)
    request.httpMethod = "HEAD"

    do {
      let (_, response) = try await urlSession.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse else {
        return nil
      }

      switch httpResponse.statusCode {
      case 200 ..< 400:
        return url
      default:
        return nil
      }
    } catch {
      return nil
    }
  }

  private func musicBrainzSearchURL(barcode: String) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "musicbrainz.org"
    components.path = "/ws/2/release/"
    components.queryItems = [
      URLQueryItem(name: "query", value: "barcode:\(barcode)"),
      URLQueryItem(name: "limit", value: "1"),
      URLQueryItem(name: "fmt", value: "json"),
    ]
    return components.url
  }

  private static let defaultUserAgent = "Records/1.0 (com.ivopintodasilva.records)"
}

private struct MusicBrainzSearchResponse: Decodable {
  let releases: [MusicBrainzRelease]
}

private struct MusicBrainzRelease: Decodable {
  let id: String
  let title: String
  let artistCredit: [MusicBrainzArtistCredit]

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case artistCredit = "artist-credit"
  }
}

private struct MusicBrainzArtistCredit: Decodable {
  let name: String?
  let joinphrase: String?
  let artist: MusicBrainzArtist?

  var displayNamePart: String {
    let base = name ?? artist?.name ?? ""
    return base + (joinphrase ?? "")
  }
}

private struct MusicBrainzArtist: Decodable {
  let name: String
}

private extension [MusicBrainzArtistCredit] {
  var displayName: String? {
    guard !isEmpty else { return nil }
    let combined = map(\.displayNamePart).joined()
    return combined.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
