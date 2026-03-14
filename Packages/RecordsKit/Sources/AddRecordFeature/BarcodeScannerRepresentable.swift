import SwiftUI
import VisionKit

  /// A SwiftUI wrapper around `DataScannerViewController` that reports
  /// the first recognised barcode payload back through a callback.
  ///
  /// The representable is shown by ``AddRecordView`` when the feature
  /// phase is `.scanning`. Once a barcode is detected the view sends
  /// `.barcodeScanned` to the store; errors are forwarded as
  /// `.barcodeScanFailed`.
  @available(iOS 16.0, *)
struct BarcodeScannerRepresentable: UIViewControllerRepresentable {
    let onBarcodeScanned: (String) -> Void
    let onError: () -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
      let scanner = DataScannerViewController(
        recognizedDataTypes: [.barcode()],
        qualityLevel: .balanced,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: true
      )
      scanner.delegate = context.coordinator
      // Defer to next run-loop so the view controller is in the hierarchy.
      DispatchQueue.main.async {
        try? scanner.startScanning()
      }
      return scanner
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context _: Context) {
      if !uiViewController.isScanning {
        try? uiViewController.startScanning()
      }
    }

    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator _: Coordinator) {
      uiViewController.stopScanning()
    }

    func makeCoordinator() -> Coordinator {
      Coordinator(onBarcodeScanned: onBarcodeScanned, onError: onError)
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
      private let onBarcodeScanned: (String) -> Void
      private let onError: () -> Void

      /// Prevents reporting more than one barcode per scan session.
      private var hasEmittedBarcode = false

      init(
        onBarcodeScanned: @escaping (String) -> Void,
        onError: @escaping () -> Void
      ) {
        self.onBarcodeScanned = onBarcodeScanned
        self.onError = onError
      }

      // MARK: DataScannerViewControllerDelegate

      func dataScanner(_: DataScannerViewController, didTapOn _: RecognizedItem) {}

      func dataScanner(
        _: DataScannerViewController,
        didAdd addedItems: [RecognizedItem],
        allItems _: [RecognizedItem]
      ) {
        guard !hasEmittedBarcode else { return }
        for item in addedItems {
          guard case let .barcode(barcode) = item,
                let payload = barcode.payloadStringValue,
                !payload.isEmpty
          else {
            continue
          }
          hasEmittedBarcode = true
          onBarcodeScanned(payload)
          return
        }
      }

      func dataScanner(
        _: DataScannerViewController,
        becameUnavailableWithError _: DataScannerViewController.ScanningUnavailable
      ) {
        onError()
      }
    }
}
