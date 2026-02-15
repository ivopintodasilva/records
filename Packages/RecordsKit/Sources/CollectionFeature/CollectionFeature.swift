import ComposableArchitecture
import Dependencies
import Foundation

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
