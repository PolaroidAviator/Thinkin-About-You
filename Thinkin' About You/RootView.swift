//
//  RootView.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/5/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        Group {
            if !session.isReady {
                VStack {
                    ProgressView()
                    Text("Connecting to Firebase…")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.1))
            } else {
                PairingView()
            }
        }
    }
}
