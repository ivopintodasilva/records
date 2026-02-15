import CollectionFeature
import ComposableArchitecture
import SwiftUI

public struct AppView: View {
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
    CollectionView(
      store: store.scope(state: \.collection, action: \.collection)
    )
  }
}
