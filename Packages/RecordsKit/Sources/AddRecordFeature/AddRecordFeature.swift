import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct AddRecordFeature {
  @Dependency(\.barcodeScannerClient) private var barcodeScannerClient
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.recordLookupClient) private var recordLookupClient

  /// Failure reasons the add-record flow can encounter.
  public enum FailureReason: Equatable, Sendable {
    case scannerUnavailable
    case scanFailed
    case lookupFailed
  }

  /// Phases of the add-record state machine.
  public enum Phase: Equatable {
    case idle
    case scanning
    case lookingUp(barcode: String)
    case failed(FailureReason)
  }

  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var phase: Phase

    public init(phase: Phase = .idle) {
      self.phase = phase
    }
  }

  public struct Record: Equatable, Sendable {
    public let title: String
    public let artist: String
    public let coverURL: URL?

    public init(title: String, artist: String, coverURL: URL?) {
      self.title = title
      self.artist = artist
      self.coverURL = coverURL
    }
  }

  public enum Action: Equatable {
    case barcodeScanned(String)
    case barcodeScanFailed
    case cancelButtonTapped
    case delegate(DelegateAction)
    case onAppear
    case recordLookupFailed
    case recordResolved(Record)
    case retryButtonTapped
  }

  public enum DelegateAction: Equatable {
    case didResolveRecord(Record)
  }

  private enum CancelID {
    case lookup
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard state.phase == .idle else { return .none }
        guard barcodeScannerClient.isSupported() else {
          state.phase = .failed(.scannerUnavailable)
          return .none
        }
        state.phase = .scanning
        return .none

      case .retryButtonTapped:
        state.phase = .scanning
        return .none

      case let .barcodeScanned(barcode):
        state.phase = .lookingUp(barcode: barcode)
        let lookupClient = recordLookupClient
        return .run { send in
          do {
            let record = try await lookupClient.lookup(barcode)
            await send(.recordResolved(record))
          } catch is CancellationError {
            return
          } catch {
            await send(.recordLookupFailed)
          }
        }
        .cancellable(id: CancelID.lookup, cancelInFlight: true)

      case let .recordResolved(record):
        state.phase = .idle
        return .send(.delegate(.didResolveRecord(record)))

      case .barcodeScanFailed:
        state.phase = .failed(.scanFailed)
        return .none

      case .recordLookupFailed:
        state.phase = .failed(.lookupFailed)
        return .none

      case .cancelButtonTapped:
        state.phase = .idle
        let dismiss = dismiss
        return .merge(
          .cancel(id: CancelID.lookup),
          .run { _ in await dismiss() }
        )

      case .delegate:
        return .none
      }
    }
  }
}
