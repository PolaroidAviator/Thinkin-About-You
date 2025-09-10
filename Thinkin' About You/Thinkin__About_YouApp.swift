//
//  Thinkin__About_YouApp.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/5/25.
//

import SwiftUI
import FirebaseCore

@main
struct ImThinkingAboutYouApp: App {
    init() {
        FirebaseApp.configure()   // initialize Firebase
    }

    var body: some Scene {
        WindowGroup {
            RootView()  // our new root screen
                .environmentObject(SessionManager.shared)
        }
    }
}
