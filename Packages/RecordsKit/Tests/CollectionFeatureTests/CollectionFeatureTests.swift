@testable import AddRecordFeature
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

    await store.send(.addRecordButtonTapped) {
      $0.addRecord = AddRecordFeature.State()
    }
  }

  @MainActor
  func testSearchQueryChanged() async {
    let store = TestStore(initialState: CollectionFeature.State()) {
      CollectionFeature()
    }

    await store.send(.searchQueryChanged("Miles")) {
      $0.searchQuery = "Miles"
    }
  }

  @MainActor
  func testSearchFocusChanged() async {
    let store = TestStore(initialState: CollectionFeature.State()) {
      CollectionFeature()
    }

    await store.send(.searchFocusChanged(true)) {
      $0.isSearchFocused = true
    }
  }

  @MainActor
  func testAddButtonClearsSearchWhenFocused() async {
    let store = TestStore(
      initialState: CollectionFeature.State(
        records: CollectionFeature.State.sampleRecords,
        searchQuery: "abc",
        isSearchFocused: true
      )
    ) {
      CollectionFeature()
    }

    await store.send(.addRecordButtonTapped) {
      $0.searchQuery = ""
      $0.isSearchFocused = false
    }
  }

  @MainActor
  func testDelegateResolvedRecordAppendsToCollectionAndDismisses() async {
    let store = TestStore(initialState: CollectionFeature.State()) {
      CollectionFeature()
    }

    await store.send(.addRecordButtonTapped) {
      $0.addRecord = AddRecordFeature.State()
    }

    let initialCount = store.state.records.count
    let resolvedRecord = AddRecordFeature.Record(
      title: "Dummy",
      artist: "Artist",
      coverURL: nil
    )

    await store.send(
      .addRecord(.presented(.delegate(.didResolveRecord(resolvedRecord))))
    ) {
      $0.addRecord = nil
      XCTAssertEqual($0.records.count, initialCount + 1)
      XCTAssertEqual($0.records.last?.title, "Dummy")
      XCTAssertEqual($0.records.last?.artist, "Artist")
      XCTAssertEqual($0.records.last?.coverSystemImageName, "opticaldisc")
    }
  }

  @MainActor
  func testDismissedAddRecordFlowClearsPresentationState() async {
    let store = TestStore(initialState: CollectionFeature.State(addRecord: AddRecordFeature.State(), records: [])) {
      CollectionFeature()
    }

    await store.send(.addRecord(.dismiss)) {
      $0.addRecord = nil
    }
  }
}
