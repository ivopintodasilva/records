import ComposableArchitecture
import Foundation

@Reducer
public struct CollectionFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var records: IdentifiedArrayOf<Record>

    public init() {
      records = Self.sampleRecords
    }

    public init(records: IdentifiedArrayOf<Record>) {
      self.records = records
    }

    public static let sampleRecords: IdentifiedArrayOf<Record> = [
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

  public struct Record: Equatable, Identifiable {
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
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .addRecordButtonTapped:
        .none
      }
    }
  }
}
