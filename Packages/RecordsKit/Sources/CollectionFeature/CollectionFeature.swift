import AddRecordFeature
import ComposableArchitecture
import Foundation

@Reducer
public struct CollectionFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    @Presents public var addRecord: AddRecordFeature.State?
    public var records: IdentifiedArrayOf<Record>
    public var searchQuery = ""
    public var isSearchFocused = false

    public init() {
      addRecord = nil
      records = Self.sampleRecords
    }

    public init(
      addRecord: AddRecordFeature.State? = nil,
      records: IdentifiedArrayOf<Record>,
      searchQuery: String = "",
      isSearchFocused: Bool = false
    ) {
      self.addRecord = addRecord
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
    case addRecord(PresentationAction<AddRecordFeature.Action>)
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
        } else {
          state.addRecord = .init()
        }
        return .none

      case let .addRecord(.presented(.delegate(.didResolveRecord(record)))):
        state.records.append(
          Record(
            id: UUID(),
            title: record.title,
            artist: record.artist,
            coverSystemImageName: "opticaldisc"
          )
        )
        state.addRecord = nil
        return .none

      case .addRecord:
        return .none

      case let .searchFocusChanged(isFocused):
        state.isSearchFocused = isFocused
        return .none

      case let .searchQueryChanged(query):
        state.searchQuery = query
        return .none
      }
    }
    .ifLet(\.$addRecord, action: \.addRecord) {
      AddRecordFeature()
    }
  }
}
