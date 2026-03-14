//
//  recordsApp.swift
//  records
//
//  Created by Ivo Silva on 08/02/2026.
//

import SwiftUI
import XCTestDynamicOverlay

@main
struct RecordsApp: App {
  var body: some Scene {
    WindowGroup {
      if _XCTIsTesting {
        EmptyView()
      } else {
        ContentView()
      }
    }
  }
}
