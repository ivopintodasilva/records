import ComposableArchitecture
import Localization
import SwiftUI

public struct CollectionView: View {
  private let store: StoreOf<CollectionFeature>
  @FocusState private var isSearchFieldFocused: Bool

  public init(store: StoreOf<CollectionFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationView {
      WithViewStore(store, observe: { $0 }, content: { viewStore in
        ScrollView {
          VStack(spacing: 12) {
            ForEach(Array(recordRows(from: Array(viewStore.records)).enumerated()), id: \.offset) { _, row in
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
        .safeAreaInset(edge: .bottom, spacing: 0) {
          HStack(spacing: 0) {
            bottomControls(viewStore: viewStore)
          }
          .padding(.leading, 16)
          .padding(.trailing, 16)
          .padding(.bottom, 12)
        }
        .navigationTitle(L10n.Collection.Navigation.title)
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: isSearchFieldFocused) { isFocused in
          viewStore.send(.searchFocusChanged(isFocused), animation: .easeInOut(duration: 0.2))
        }
        .onChange(of: viewStore.isSearchFocused) { isFocused in
          if isSearchFieldFocused != isFocused {
            withAnimation(.easeInOut(duration: 0.2)) {
              isSearchFieldFocused = isFocused
            }
          }
        }
      })
    }
  }

  private func bottomControls(viewStore: ViewStoreOf<CollectionFeature>) -> some View {
    HStack(spacing: 10) {
      addRecordButton(isSearchFocused: viewStore.isSearchFocused) {
        viewStore.send(.addRecordButtonTapped, animation: .easeInOut(duration: 0.2))
      }

      searchBar(viewStore: viewStore)
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

  private func addRecordButton(isSearchFocused: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      bottomControlButtonGlyph(isSearchFocused: isSearchFocused)
        .padding(6)
    }
    .frame(width: 56, height: 56)
    .collectionAddRecordButtonStyle()
    .collectionAddRecordAccessibilityLabel(isSearchFocused: isSearchFocused)
  }

  private func bottomControlButtonGlyph(isSearchFocused: Bool) -> some View {
    Image(systemName: "plus")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .foregroundColor(.secondary)
      .rotationEffect(.degrees(isSearchFocused ? 45 : 0))
      .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
  }

  private func searchBar(viewStore: ViewStoreOf<CollectionFeature>) -> some View {
    HStack(spacing: 8) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.secondary)
      TextField(
        L10n.Collection.Search.placeholder,
        text: viewStore.binding(
          get: \.searchQuery,
          send: CollectionFeature.Action.searchQueryChanged
        )
      )
      .textInputAutocapitalization(.never)
      .disableAutocorrection(true)
      .focused($isSearchFieldFocused)
    }
    .padding(.horizontal, 14)
    .frame(height: 56)
    .clipShape(Capsule())
    .glassEffect(.clear, in: Capsule())
  }
}

private extension View {
  func collectionAddRecordAccessibilityLabel(isSearchFocused: Bool) -> some View {
    accessibilityLabel(isSearchFocused ? L10n.Collection.Actions.closeSearch : L10n.Collection.Actions.addRecord)
  }

  func collectionAddRecordButtonStyle() -> some View {
    buttonStyle(.glass(.clear))
      .clipShape(Circle())
  }
}
