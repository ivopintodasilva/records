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
      WithViewStore(store, observe: { $0 }, content: { viewStore in
        ZStack(alignment: .bottomLeading) {
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
          addRecordButton {
            viewStore.send(.addRecordButtonTapped)
          }
          .padding(16)
        }
        .collectionNavigationTitle()
      })
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

  private func addRecordButton(action: @escaping () -> Void) -> some View {
    Button(action: action) {
      addRecordIcon()
        .padding(4)
    }
    .frame(width: 56, height: 56)
    .collectionAddRecordButtonStyle()
    .collectionAddRecordAccessibilityLabel()
  }

  @ViewBuilder
  private func addRecordIcon() -> some View {
    #if os(macOS)
      if #available(macOS 11.0, *) {
        Image(systemName: "plus")
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.primary)
      } else {
        Text("+")
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(.primary)
      }
    #else
      Image(systemName: "plus")
        .resizable()
        .aspectRatio(contentMode: ContentMode.fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.primary)
    #endif
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

  @ViewBuilder
  func collectionAddRecordAccessibilityLabel() -> some View {
    #if os(macOS)
      if #available(macOS 11.0, *) {
        accessibilityLabel(L10n.Collection.Actions.addRecord)
      } else {
        self
      }
    #else
      accessibilityLabel(L10n.Collection.Actions.addRecord)
    #endif
  }

  @ViewBuilder
  func collectionAddRecordButtonStyle() -> some View {
    #if os(macOS)
      if #available(macOS 26.0, *) {
        buttonStyle(.glass)
      } else {
        buttonStyle(.plain)
          .background(
            Circle()
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [Color.white.opacity(0.42), Color.white.opacity(0.2)]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
          )
          .overlay(
            Circle()
              .stroke(Color.white.opacity(0.5), lineWidth: 1)
          )
          .shadow(color: Color.black.opacity(0.24), radius: 14, x: 0, y: 6)
      }
    #else
      if #available(iOS 26.0, *) {
        buttonStyle(.glass(.clear))
      } else {
        buttonStyle(.plain)
          .background(
            Circle()
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [Color.white.opacity(0.42), Color.white.opacity(0.2)]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
          )
          .overlay(
            Circle()
              .stroke(Color.white.opacity(0.5), lineWidth: 1)
          )
          .shadow(color: Color.black.opacity(0.24), radius: 14, x: 0, y: 6)
      }
    #endif
  }
}
