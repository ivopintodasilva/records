import ComposableArchitecture
import SwiftUI

public struct AddRecordView: View {
  private let store: StoreOf<AddRecordFeature>

  public init(store: StoreOf<AddRecordFeature>) {
    self.store = store
  }

  public var body: some View {
    Color.clear
  }
}
