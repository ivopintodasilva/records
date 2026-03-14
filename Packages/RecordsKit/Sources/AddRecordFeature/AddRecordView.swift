import ComposableArchitecture
import Localization
import SwiftUI
import VisionKit

public struct AddRecordView: View {
  private let store: StoreOf<AddRecordFeature>

  public init(store: StoreOf<AddRecordFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      switch store.phase {
      case .idle:
        Color.clear

      case .scanning:
        scanningPhaseView

      case .lookingUp:
        lookingUpPhaseView

      case let .failed(reason):
        failedPhaseView(reason: reason)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear { store.send(.onAppear) }
  }

  // MARK: - Scanning

  @ViewBuilder
  private var scanningPhaseView: some View {
    if #available(iOS 16.0, *), DataScannerViewController.isSupported {
      ZStack(alignment: .bottom) {
        BarcodeScannerRepresentable(
          onBarcodeScanned: { barcode in
            store.send(.barcodeScanned(barcode))
          },
          onError: {
            store.send(.barcodeScanFailed)
          }
        )

        scannerOverlay
      }
      .ignoresSafeArea()
    } else {
      scannerUnsupportedView
    }
  }

  private var scannerOverlay: some View {
    ZStack(alignment: .bottom) {
      Rectangle()
        .fill(.ultraThinMaterial)
        .frame(height: 48)

      Text(L10n.AddRecord.Scanner.instruction)
        .font(.subheadline)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
    }
  }

  // MARK: - Looking Up

  private var lookingUpPhaseView: some View {
    VStack(spacing: 16) {
      Spacer()

      ProgressView()
        .controlSize(.large)

      Text(L10n.AddRecord.Lookup.loading)
        .font(.headline)

      Spacer()

      Button(role: .cancel) {
        store.send(.cancelButtonTapped)
      } label: {
        Text(L10n.AddRecord.Actions.cancel)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bordered)
      .padding()
    }
  }

  // MARK: - Failed

  private func failedPhaseView(reason: AddRecordFeature.FailureReason) -> some View {
    VStack(spacing: 16) {
      Spacer()

      Image(systemName: failureIconName(for: reason))
        .font(.system(size: 48))
        .foregroundStyle(.secondary)

      VStack(spacing: 4) {
        Text(failureTitle(for: reason))
          .font(.headline)

        Text(failureMessage(for: reason))
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
      }

      Spacer()

      // No retry button in failure states; users dismiss via the sheet.
    }
  }

  // MARK: - Unsupported fallback

  private var scannerUnsupportedView: some View {
    VStack(spacing: 16) {
      Spacer()

      Image(systemName: "camera.badge.ellipsis")
        .font(.system(size: 48))
        .foregroundStyle(.secondary)

      VStack(spacing: 4) {
        Text(L10n.AddRecord.Failed.Unsupported.title)
          .font(.headline)

        Text(L10n.AddRecord.Failed.Unsupported.message)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)
      }

      Spacer()
    }
  }

  // MARK: - Helpers

  private func failureIconName(for reason: AddRecordFeature.FailureReason) -> String {
    switch reason {
    case .scanFailed:
      "barcode.viewfinder"
    case .lookupFailed:
      "magnifyingglass"
    }
  }

  private func failureTitle(for reason: AddRecordFeature.FailureReason) -> String {
    switch reason {
    case .scanFailed:
      L10n.AddRecord.Failed.Scan.title
    case .lookupFailed:
      L10n.AddRecord.Failed.Lookup.title
    }
  }

  private func failureMessage(for reason: AddRecordFeature.FailureReason) -> String {
    switch reason {
    case .scanFailed:
      L10n.AddRecord.Failed.Scan.message
    case .lookupFailed:
      L10n.AddRecord.Failed.Lookup.message
    }
  }
}
