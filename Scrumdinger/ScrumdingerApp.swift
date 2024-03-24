//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Atakan Zengin on 05/07/2023.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $scrums)
        }
    }
}
