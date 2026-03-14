@testable import AddRecordFeature
import Foundation
import XCTest

final class RecordLookupClientTests: XCTestCase {
  func testLookupMusicBrainzReturnsRecord() async throws {
    let session = makeSession()
    let service = RecordLookupService(urlSession: session, userAgent: "RecordsTests/1.0")
    let releaseID = "f5f88d07-1b1d-4c33-9b19-6f5e6d1d9ed9"
    let expectedCoverURL = URL(string: "https://coverartarchive.org/release/\(releaseID)/front")

    URLProtocolStub.requestHandler = { request in
      guard let url = request.url else {
        throw URLError(.badURL)
      }

      if url.host == "musicbrainz.org" {
        XCTAssertEqual(request.value(forHTTPHeaderField: "User-Agent"), "RecordsTests/1.0")
        let json = """
        {
          "releases": [
            {
              "id": "\(releaseID)",
              "title": "Discovery",
              "artist-credit": [
                { "name": "Daft Punk" }
              ]
            }
          ]
        }
        """
        let response = try makeResponse(url: url, statusCode: 200)
        return (response, Data(json.utf8))
      }

      if url.host == "coverartarchive.org" {
        XCTAssertEqual(request.httpMethod, "HEAD")
        let response = try makeResponse(url: url, statusCode: 200)
        return (response, Data())
      }

      throw URLError(.unsupportedURL)
    }

    defer { URLProtocolStub.requestHandler = nil }

    let record = try await service.lookup(barcode: "724349825216")

    XCTAssertEqual(record.title, "Discovery")
    XCTAssertEqual(record.artist, "Daft Punk")
    XCTAssertEqual(record.coverURL, expectedCoverURL)
  }

  func testLookupMusicBrainzReturnsNotFoundWhenEmpty() async {
    let session = makeSession()
    let service = RecordLookupService(urlSession: session, userAgent: "RecordsTests/1.0")

    URLProtocolStub.requestHandler = { request in
      guard let url = request.url else {
        throw URLError(.badURL)
      }

      let json = """
      {
        "releases": []
      }
      """
      let response = try makeResponse(url: url, statusCode: 200)
      return (response, Data(json.utf8))
    }

    defer { URLProtocolStub.requestHandler = nil }

    await XCTAssertThrowsErrorAsync(try service.lookup(barcode: "000000000000")) { error in
      XCTAssertEqual(error as? RecordLookupClientError, .notFound)
    }
  }
}

private func makeSession() -> URLSession {
  let configuration = URLSessionConfiguration.ephemeral
  configuration.protocolClasses = [URLProtocolStub.self]
  return URLSession(configuration: configuration)
}

private func makeResponse(url: URL, statusCode: Int) throws -> HTTPURLResponse {
  guard let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
    throw URLError(.badServerResponse)
  }
  return response
}

private final class URLProtocolStub: URLProtocol {
  nonisolated(unsafe) static var requestHandler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?

  // swiftlint:disable:next static_over_final_class
  override class func canInit(with _: URLRequest) -> Bool {
    true
  }

  // swiftlint:disable:next static_over_final_class
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }

  override func startLoading() {
    guard let handler = Self.requestHandler else {
      client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
      return
    }

    do {
      let (response, data) = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }

  override func stopLoading() {}
}

private func XCTAssertThrowsErrorAsync(
  _ expression: @autoclosure () async throws -> some Any,
  _ handler: (Error) -> Void
) async {
  do {
    _ = try await expression()
    XCTFail("Expected error to be thrown.")
  } catch {
    handler(error)
  }
}
