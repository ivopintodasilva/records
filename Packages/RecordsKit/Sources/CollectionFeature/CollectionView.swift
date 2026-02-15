import ComposableArchitecture
import SwiftUI

public struct CollectionView: View {
  private let store: StoreOf<CollectionFeature>

  public init(store: StoreOf<CollectionFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }, content: { viewStore in
      VStack(alignment: .leading, spacing: 12) {
        Text("My Collection")
          .font(.title)

        HStack {
          TextField(
            "Record title",
            text: viewStore.binding(
              get: \.newRecordTitle,
              send: CollectionFeature.Action.newRecordTitleChanged
            )
          )
          .textFieldStyle(.roundedBorder)

          Button("Add") {
            viewStore.send(.addButtonTapped)
          }
          .buttonStyle(.borderedProminent)
        }

        if viewStore.records.isEmpty {
          Text("No records yet")
            .foregroundStyle(.secondary)
        } else {
          List {
            ForEach(viewStore.records) { record in
              Text(record.title)
            }
          }
        }
      }
      .padding()
    })
  }
}
