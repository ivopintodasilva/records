import CollectionFeature
import ComposableArchitecture

@Reducer
public struct AppFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var collection = CollectionFeature.State()

    public init() {}
  }

  public enum Action {
    case collection(CollectionFeature.Action)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.collection, action: \.collection) {
      CollectionFeature()
    }
  }
}
