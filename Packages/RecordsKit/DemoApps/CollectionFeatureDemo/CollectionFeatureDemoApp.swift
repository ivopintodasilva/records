import CollectionFeature
import ComposableArchitecture
import SwiftUI

@main
struct CollectionFeatureDemoApp: App {
  var body: some Scene {
    WindowGroup {
      CollectionView(
        store: Store(initialState: CollectionFeature.State()) {
          CollectionFeature()
        }
      )
    }
  }
}
