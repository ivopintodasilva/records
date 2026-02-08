//
//  ContentView.swift
//  records
//
//  Created by Ivo Silva on 08/02/2026.
//

import CollectionFeature
import ComposableArchitecture
import SwiftUI

struct ContentView: View {
  private let store = Store(initialState: CollectionFeature.State()) {
    CollectionFeature()
  }

  var body: some View {
    CollectionFeatureView(store: store)
  }
}

#Preview {
  ContentView()
}
