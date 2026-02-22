import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct AddRecordFeature {
  @Dependency(\.barcodeScannerClient) private var barcodeScannerClient
  @Dependency(\.recordLookupClient) private var recordLookupClient

  public enum Phase: Equatable {
    case idle
    case scanning
    case lookingUp(barcode: String)
    case failed
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
    case cancelButtonTapped
    case delegate(DelegateAction)
    case barcodeScanned(String)
    case barcodeScanFailed
    case recordLookupFailed
    case recordResolved(Record)
    case scanButtonTapped
  }

  public enum DelegateAction: Equatable {
    case didResolveRecord(Record)
  }

  private enum CancelID {
    case scan
    case lookup
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .scanButtonTapped:
        state.phase = .scanning
        let scanner = barcodeScannerClient
        return .run { send in
          do {
            let barcode = try await scanner.scan()
            await send(.barcodeScanned(barcode))
          } catch is CancellationError {
            return
          } catch {
            await send(.barcodeScanFailed)
          }
        }
        .cancellable(id: CancelID.scan, cancelInFlight: true)

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

      case .barcodeScanFailed, .recordLookupFailed:
        state.phase = .failed
        return .none

      case .cancelButtonTapped:
        state.phase = .idle
        return .merge(
          .cancel(id: CancelID.scan),
          .cancel(id: CancelID.lookup)
        )

      case .delegate:
        return .none
      }
    }
  }
}
