@testable import AddRecordFeature
import ComposableArchitecture
import XCTest

final class AddRecordFeatureTests: XCTestCase {
  // MARK: - onAppear

  @MainActor
  func testOnAppearStartsScanningWhenSupported() async {
    let store = TestStore(initialState: AddRecordFeature.State()) {
      AddRecordFeature()
    } withDependencies: {
      $0.barcodeScannerClient.isSupported = { true }
    }

    await store.send(.onAppear) {
      $0.phase = .scanning
    }
  }

  @MainActor
  func testOnAppearFailsWhenUnsupported() async {
    let store = TestStore(initialState: AddRecordFeature.State()) {
      AddRecordFeature()
    } withDependencies: {
      $0.barcodeScannerClient.isSupported = { false }
    }

    await store.send(.onAppear) {
      $0.phase = .failed(.scannerUnavailable)
    }
  }

  @MainActor
  func testOnAppearIsIgnoredWhenAlreadyScanning() async {
    let store = TestStore(initialState: AddRecordFeature.State(phase: .scanning)) {
      AddRecordFeature()
    }

    await store.send(.onAppear)
    // Phase should remain unchanged — no state mutation expected.
  }

  // MARK: - Happy path

  @MainActor
  func testScanAndLookupSuccessEmitsDelegate() async {
    let resolvedRecord = AddRecordFeature.Record(
      title: "Discovery",
      artist: "Daft Punk",
      coverURL: nil
    )

    let store = TestStore(initialState: AddRecordFeature.State()) {
      AddRecordFeature()
    } withDependencies: {
      $0.barcodeScannerClient.isSupported = { true }
      $0.recordLookupClient.lookup = { barcode in
        XCTAssertEqual(barcode, "724349825216")
        return resolvedRecord
      }
    }

    await store.send(.onAppear) {
      $0.phase = .scanning
    }

    // View-driven: the scanner representable reports the barcode.
    await store.send(.barcodeScanned("724349825216")) {
      $0.phase = .lookingUp(barcode: "724349825216")
    }

    await store.receive(.recordResolved(resolvedRecord)) {
      $0.phase = .idle
    }

    await store.receive(.delegate(.didResolveRecord(resolvedRecord)))
  }

  // MARK: - Failure paths

  @MainActor
  func testBarcodeScanFailedTransitionsToFailed() async {
    let store = TestStore(initialState: AddRecordFeature.State(phase: .scanning)) {
      AddRecordFeature()
    }

    await store.send(.barcodeScanFailed) {
      $0.phase = .failed(.scanFailed)
    }
  }

  @MainActor
  func testLookupFailureTransitionsToFailed() async {
    let store = TestStore(initialState: AddRecordFeature.State()) {
      AddRecordFeature()
    } withDependencies: {
      $0.barcodeScannerClient.isSupported = { true }
      $0.recordLookupClient.lookup = { _ in
        throw RecordLookupClientError.notImplemented
      }
    }

    await store.send(.onAppear) {
      $0.phase = .scanning
    }

    await store.send(.barcodeScanned("000000000000")) {
      $0.phase = .lookingUp(barcode: "000000000000")
    }

    await store.receive(.recordLookupFailed) {
      $0.phase = .failed(.lookupFailed)
    }
  }

  // MARK: - Retry

  @MainActor
  func testRetryFromFailedRestartsScanning() async {
    let store = TestStore(
      initialState: AddRecordFeature.State(phase: .failed(.scanFailed))
    ) {
      AddRecordFeature()
    }

    await store.send(.retryButtonTapped) {
      $0.phase = .scanning
    }
  }

  // MARK: - Cancel

  @MainActor
  func testCancelDuringScanningDismisses() async {
    let dismissed = LockIsolated(false)

    let store = TestStore(initialState: AddRecordFeature.State(phase: .scanning)) {
      AddRecordFeature()
    } withDependencies: {
      $0.dismiss = DismissEffect { dismissed.setValue(true) }
    }

    await store.send(.cancelButtonTapped) {
      $0.phase = .idle
    }

    XCTAssertTrue(dismissed.value)
  }

  @MainActor
  func testCancelDuringLookupCancelsAndDismisses() async {
    let dismissed = LockIsolated(false)

    let store = TestStore(
      initialState: AddRecordFeature.State(phase: .lookingUp(barcode: "123"))
    ) {
      AddRecordFeature()
    } withDependencies: {
      $0.dismiss = DismissEffect { dismissed.setValue(true) }
    }

    await store.send(.cancelButtonTapped) {
      $0.phase = .idle
    }

    XCTAssertTrue(dismissed.value)
  }
}
