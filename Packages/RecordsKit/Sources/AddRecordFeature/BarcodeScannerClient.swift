import Dependencies
import Foundation

/// Dependency providing barcode scanner availability information.
///
/// The actual camera-based scanning is driven by the view layer
/// through ``BarcodeScannerRepresentable``. This client exposes
/// a platform-level capability flag so the reducer can gate the flow
/// and tests can exercise both paths.
///
/// The runtime ``DataScannerViewController/isSupported`` check is
/// main-actor-isolated and is performed by the view before showing
/// the scanner. The client's ``isSupported`` provides a conservative
/// platform-level check (true on iOS, false on macOS).
public struct BarcodeScannerClient: Sendable {
  public var isSupported: @Sendable () -> Bool

  public init(isSupported: @escaping @Sendable () -> Bool) {
    self.isSupported = isSupported
  }
}

extension BarcodeScannerClient: DependencyKey {
  public static let liveValue = Self {
    #if os(iOS)
      return true
    #else
      return false
    #endif
  }

  public static let testValue = Self {
    unimplemented("BarcodeScannerClient.isSupported", placeholder: false)
  }
}

public extension DependencyValues {
  var barcodeScannerClient: BarcodeScannerClient {
    get { self[BarcodeScannerClient.self] }
    set { self[BarcodeScannerClient.self] = newValue }
  }
}
