import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
public struct CollectionFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var records: IdentifiedArrayOf<Record> = []
    public var newRecordTitle: String = ""

    public init() {}
  }

  public struct Record: Equatable, Identifiable {
    public let id: UUID
    public var title: String

    public init(id: UUID, title: String) {
      self.id = id
      self.title = title
    }
  }

  public enum Action {
    case addButtonTapped
    case newRecordTitleChanged(String)
  }

  @Dependency(\.uuid) private var uuid

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        let trimmed = state.newRecordTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .none }
        state.records.append(Record(id: uuid(), title: trimmed))
        state.newRecordTitle = ""
        return .none

      case let .newRecordTitleChanged(value):
        state.newRecordTitle = value
        return .none
      }
    }
  }
}

public struct CollectionFeatureView: View {
  private let store: StoreOf<CollectionFeature>

  public init(store: StoreOf<CollectionFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }, content: { viewStore in
      VStack(alignment: .leading, spacing: 12) {
        Text("My Collection")
          .font(.title)

        HStack {
          TextField(
            "Record title",
            text: viewStore.binding(
              get: \.newRecordTitle,
              send: CollectionFeature.Action.newRecordTitleChanged
            )
          )
          .textFieldStyle(.roundedBorder)

          Button("Add") {
            viewStore.send(.addButtonTapped)
          }
          .buttonStyle(.borderedProminent)
        }

        if viewStore.records.isEmpty {
          Text("No records yet")
            .foregroundStyle(.secondary)
        } else {
          List {
            ForEach(viewStore.records) { record in
              Text(record.title)
            }
          }
        }
      }
      .padding()
    })
  }
}
