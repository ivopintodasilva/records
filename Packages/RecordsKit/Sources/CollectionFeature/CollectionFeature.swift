import ComposableArchitecture
import Foundation

@Reducer
public struct CollectionFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var records: IdentifiedArrayOf<Record>
    public var searchQuery = ""
    public var isSearchFocused = false

    public init() {
      records = Self.sampleRecords
    }

    public init(
      records: IdentifiedArrayOf<Record>,
      searchQuery: String = "",
      isSearchFocused: Bool = false
    ) {
      self.records = records
      self.searchQuery = searchQuery
      self.isSearchFocused = isSearchFocused
    }

    public static var sampleRecords: IdentifiedArrayOf<Record> {
      [
        Record(
          id: UUID(),
          title: "Kind of Blue",
          artist: "Miles Davis",
          coverSystemImageName: "music.note.house"
        ),
        Record(
          id: UUID(),
          title: "Blue Train",
          artist: "John Coltrane",
          coverSystemImageName: "opticaldisc"
        ),
        Record(
          id: UUID(),
          title: "Abbey Road",
          artist: "The Beatles",
          coverSystemImageName: "music.quarternote.3"
        ),
        Record(
          id: UUID(),
          title: "Rumours",
          artist: "Fleetwood Mac",
          coverSystemImageName: "guitars"
        ),
        Record(
          id: UUID(),
          title: "Discovery",
          artist: "Daft Punk",
          coverSystemImageName: "headphones"
        ),
      ]
    }
  }

  public struct Record: Equatable, Identifiable, Sendable {
    public let id: UUID
    public var title: String
    public var artist: String
    public var coverSystemImageName: String

    public init(id: UUID, title: String, artist: String, coverSystemImageName: String) {
      self.id = id
      self.title = title
      self.artist = artist
      self.coverSystemImageName = coverSystemImageName
    }
  }

  public enum Action {
    case addRecordButtonTapped
    case searchFocusChanged(Bool)
    case searchQueryChanged(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .addRecordButtonTapped:
        if state.isSearchFocused {
          state.searchQuery = ""
          state.isSearchFocused = false
        }
        return .none

      case let .searchFocusChanged(isFocused):
        state.isSearchFocused = isFocused
        return .none

      case let .searchQueryChanged(query):
        state.searchQuery = query
        return .none
      }
    }
  }
}
