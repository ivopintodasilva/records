import Dependencies
import Foundation

public struct RecordLookupClient: Sendable {
  public var lookup: @Sendable (_ barcode: String) async throws -> AddRecordFeature.Record

  public init(_ lookup: @escaping @Sendable (_ barcode: String) async throws -> AddRecordFeature.Record) {
    self.lookup = lookup
  }
}

extension RecordLookupClient: DependencyKey {
  public static let liveValue = Self { _ in
    throw RecordLookupClientError.notImplemented
  }

  public static let testValue = Self(unimplemented("RecordLookupClient.lookup"))
}

public enum RecordLookupClientError: Error {
  case notImplemented
}

public extension DependencyValues {
  var recordLookupClient: RecordLookupClient {
    get { self[RecordLookupClient.self] }
    set { self[RecordLookupClient.self] = newValue }
  }
}
