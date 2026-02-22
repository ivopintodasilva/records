import Dependencies
import Foundation

public struct BarcodeScannerClient: Sendable {
  public var scan: @Sendable () async throws -> String

  public init(_ scan: @escaping @Sendable () async throws -> String) {
    self.scan = scan
  }
}

extension BarcodeScannerClient: DependencyKey {
  public static let liveValue = Self {
    throw BarcodeScannerClientError.notImplemented
  }

  public static let testValue = Self(unimplemented("BarcodeScannerClient.scan"))
}

public enum BarcodeScannerClientError: Error {
  case notImplemented
}

public extension DependencyValues {
  var barcodeScannerClient: BarcodeScannerClient {
    get { self[BarcodeScannerClient.self] }
    set { self[BarcodeScannerClient.self] = newValue }
  }
}
