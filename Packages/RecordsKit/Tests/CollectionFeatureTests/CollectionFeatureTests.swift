@testable import CollectionFeature
import XCTest

final class CollectionFeatureTests: XCTestCase {
  func testStateStartsWithDisplayRecords() {
    let state = CollectionFeature.State()

    XCTAssertFalse(state.records.isEmpty)
    XCTAssertEqual(state.records.count, 5)
    XCTAssertEqual(state.records.first?.title, "Kind of Blue")
    XCTAssertEqual(state.records.first?.artist, "Miles Davis")
  }
}
