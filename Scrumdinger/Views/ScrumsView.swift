//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Atakan Zengin on 24/03/2024.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    var body: some View {
        NavigationStack {
            List($scrums) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
            .navigationTitle("Daily Scrums")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Scrum")
            }
        }
        
    }
}

#Preview {
    ScrumsView(scrums: .constant(DailyScrum.sampleData))
}
