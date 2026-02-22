@testable import AddRecordFeature
import ComposableArchitecture
import XCTest

final class AddRecordFeatureTests: XCTestCase {
  @MainActor
  func testScanSuccessAndLookupSuccessEmitsDelegate() async {
    let resolvedRecord = AddRecordFeature.Record(
      title: "Discovery",
      artist: "Daft Punk",
      coverURL: nil
    )

    let store = TestStore(initialState: AddRecordFeature.State()) {
      AddRecordFeature()
    } withDependencies: {
      $0.barcodeScannerClient.scan = { "724349825216" }
      $0.recordLookupClient.lookup = { barcode in
        XCTAssertEqual(barcode, "724349825216")
        return resolvedRecord
      }
    }

    await store.send(.scanButtonTapped) {
      $0.phase = .scanning
    }

    await store.receive(.barcodeScanned("724349825216")) {
      $0.phase = .lookingUp(barcode: "724349825216")
    }

    await store.receive(.recordResolved(resolvedRecord)) {
      $0.phase = .idle
    }

    await store.receive(.delegate(.didResolveRecord(resolvedRecord)))
  }

  @MainActor
  func testScanFailureTransitionsToFailed() async {
    let store = TestStore(initialState: AddRecordFeature.State()) {
      AddRecordFeature()
    } withDependencies: {
      $0.barcodeScannerClient.scan = {
        throw BarcodeScannerClientError.notImplemented
      }
    }

    await store.send(.scanButtonTapped) {
      $0.phase = .scanning
    }

    await store.receive(.barcodeScanFailed) {
      $0.phase = .failed
    }
  }

  @MainActor
  func testCancelReturnsToIdle() async {
    let store = TestStore(initialState: AddRecordFeature.State(phase: .lookingUp(barcode: "123"))) {
      AddRecordFeature()
    }

    await store.send(.cancelButtonTapped) {
      $0.phase = .idle
    }
  }
}
