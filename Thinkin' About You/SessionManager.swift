//
//  SessionManager.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/5/25.
//

import Foundation
import FirebaseAuth

final class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var userId: String?
    @Published var isReady = false

    private init() {
        signInIfNeeded()
    }

    private func signInIfNeeded() {
        if let user = Auth.auth().currentUser {
            self.userId = user.uid
            self.isReady = true
            return
        }

        Auth.auth().signInAnonymously { [weak self] result, error in
            if let error = error {
                print("Sign-in failed: \(error)")
                return
            }
            self?.userId = result?.user.uid
            self?.isReady = true
        }
    }
}
