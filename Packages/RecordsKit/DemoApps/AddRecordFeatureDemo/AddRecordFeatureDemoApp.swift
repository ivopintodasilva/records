import AddRecordFeature
import ComposableArchitecture
import SwiftUI

@main
struct AddRecordFeatureDemoApp: App {
  var body: some Scene {
    WindowGroup {
      AddRecordView(
        store: Store(initialState: AddRecordFeature.State()) {
          AddRecordFeature()
        }
      )
    }
  }
}
