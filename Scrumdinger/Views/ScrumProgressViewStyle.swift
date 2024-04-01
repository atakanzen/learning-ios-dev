//
//  ScrumProgressViewStyle.swift
//  Scrumdinger
//
//  Created by Atakan Zengin on 01/04/2024.
//

import SwiftUI

struct ScrumProgressViewStyle: ProgressViewStyle {
    var theme: Theme
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(theme.accentColor)
                .frame(height: 20.0)
            if #available(iOS 15.0, *) {
                ProgressView(configuration)
                    .tint(theme.mainColor)
                    .frame(height: 12.0)
                    .padding(.horizontal)
            } else {
                ProgressView(configuration)
                    .frame(height: 12.0)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ProgressView(value: 0.4)
        .progressViewStyle(ScrumProgressViewStyle(theme: .bubblegum))
        .previewLayout(.sizeThatFits)
}
