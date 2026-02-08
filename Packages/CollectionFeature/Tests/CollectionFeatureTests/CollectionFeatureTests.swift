@testable import CollectionFeature
import ComposableArchitecture
import XCTest

final class CollectionFeatureTests: XCTestCase {
  func testAddRecord() async {
    let store = TestStore(initialState: CollectionFeature.State()) {
      CollectionFeature()
    } withDependencies: {
      $0.uuid = .incrementing
    }

    await store.send(.binding(.set(\.newRecordTitle, "Kind of Blue"))) {
      $0.newRecordTitle = "Kind of Blue"
    }

    await store.send(.addButtonTapped) {
      $0.newRecordTitle = ""
      $0.records = [CollectionFeature.Record(id: UUID(0), title: "Kind of Blue")]
    }
  }

  func testAddRecordIgnoresEmptyInput() async {
    let store = TestStore(initialState: CollectionFeature.State()) {
      CollectionFeature()
    }

    await store.send(.addButtonTapped)
    XCTAssertTrue(store.state.records.isEmpty)
  }
}
