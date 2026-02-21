@testable import CollectionFeature
import ComposableArchitecture
import XCTest

final class CollectionFeatureTests: XCTestCase {
  func testStateStartsWithDisplayRecords() {
    let state = CollectionFeature.State()

    XCTAssertFalse(state.records.isEmpty)
    XCTAssertEqual(state.records.count, 5)
    XCTAssertEqual(state.records.first?.title, "Kind of Blue")
    XCTAssertEqual(state.records.first?.artist, "Miles Davis")
  }

  @MainActor
  func testAddRecordButtonTapIsHandled() async {
    let store = TestStore(initialState: CollectionFeature.State()) {
      CollectionFeature()
    }

    await store.send(.addRecordButtonTapped)
  }
}
