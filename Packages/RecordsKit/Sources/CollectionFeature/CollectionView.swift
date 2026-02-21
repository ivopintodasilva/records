import ComposableArchitecture
import Localization
import SwiftUI

public struct CollectionView: View {
  private let store: StoreOf<CollectionFeature>

  public init(store: StoreOf<CollectionFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationView {
      WithViewStore(store, observe: \.records) { viewStore in
        ScrollView {
          VStack(spacing: 12) {
            ForEach(Array(recordRows(from: Array(viewStore.state)).enumerated()), id: \.offset) { _, row in
              HStack(alignment: .top, spacing: 12) {
                ForEach(row) { record in
                  recordCard(record)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if row.count == 1 {
                  Spacer()
                    .frame(maxWidth: .infinity)
                }
              }
            }
          }
          .padding()
        }
        .collectionNavigationTitle()
      }
    }
  }

  private func recordRows(from records: [CollectionFeature.Record]) -> [[CollectionFeature.Record]] {
    stride(from: 0, to: records.count, by: 2).map { index in
      Array(records[index ..< min(index + 2, records.count)])
    }
  }

  private func recordCard(_ record: CollectionFeature.Record) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.secondary.opacity(0.15))

        Text(String(record.title.prefix(1)))
          .font(.title)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
      }
      .aspectRatio(1, contentMode: .fit)

      Text(record.title)
        .font(.headline)
        .lineLimit(1)

      Text(record.artist)
        .font(.subheadline)
        .foregroundColor(.secondary)
        .lineLimit(1)
    }
    .padding(10)
    .background(Color.secondary.opacity(0.12))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

private extension View {
  @ViewBuilder
  func collectionNavigationTitle() -> some View {
    #if os(macOS)
      if #available(macOS 11.0, *) {
        navigationTitle(L10n.Collection.Navigation.title)
      } else {
        self
      }
    #else
      navigationTitle(L10n.Collection.Navigation.title)
        .navigationBarTitleDisplayMode(.large)
    #endif
  }
}
