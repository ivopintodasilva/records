import CollectionFeature
import ComposableArchitecture
import SwiftUI

public struct AppFeatureView: View {
  private let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public var body: some View {
    CollectionFeatureView(
      store: store.scope(state: \.collection, action: \.collection)
    )
  }
}

public struct AppFeatureRootView: View {
  private let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public init() {
    store = Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  }

  public var body: some View {
    AppFeatureView(store: store)
  }
}
