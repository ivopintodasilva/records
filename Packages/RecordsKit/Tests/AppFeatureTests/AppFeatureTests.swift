@testable import AppFeature
import ComposableArchitecture
import XCTest

final class AppFeatureTests: XCTestCase {
  func testInitialState() async {
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }
    XCTAssertTrue(store.state.collection.records.isEmpty)
  }
}
