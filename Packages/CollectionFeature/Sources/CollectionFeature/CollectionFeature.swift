import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
public struct CollectionFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var records: IdentifiedArrayOf<Record> = []
    @BindingState public var newRecordTitle: String = ""

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

  public enum Action: BindableAction {
    case addButtonTapped
    case binding(BindingAction<State>)
  }

  @Dependency(\.uuid) private var uuid

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        let trimmed = state.newRecordTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .none }
        state.records.append(Record(id: uuid(), title: trimmed))
        state.newRecordTitle = ""
        return .none

      case .binding:
        return .none
      }
    }
  }
}

public struct CollectionFeatureView: View {
  @Perception.Bindable private var store: StoreOf<CollectionFeature>

  public init(store: StoreOf<CollectionFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading, spacing: 12) {
        Text("My Collection")
          .font(.title)

        HStack {
          TextField("Record title", text: $store.newRecordTitle)
            .textFieldStyle(.roundedBorder)

          Button("Add") {
            store.send(.addButtonTapped)
          }
          .buttonStyle(.borderedProminent)
        }

        if store.records.isEmpty {
          Text("No records yet")
            .foregroundStyle(.secondary)
        } else {
          List {
            ForEach(store.records) { record in
              Text(record.title)
            }
          }
        }
      }
      .padding()
    }
  }
}
