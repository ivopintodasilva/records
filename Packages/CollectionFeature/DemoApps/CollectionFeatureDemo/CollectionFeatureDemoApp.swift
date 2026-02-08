import ComposableArchitecture
import CollectionFeature
import SwiftUI

@main
struct CollectionFeatureDemoApp: App {
  var body: some Scene {
    WindowGroup {
      CollectionFeatureView(
        store: Store(initialState: CollectionFeature.State()) {
          CollectionFeature()
        }
      )
    }
  }
}
