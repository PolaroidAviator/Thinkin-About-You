//
//  ChatViewModel.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/6/25.
//


import Foundation
import FirebaseFirestore

final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let connectionId: String
    let currentUserId: String

    init(connectionId: String, currentUserId: String) {
        self.connectionId = connectionId
        self.currentUserId = currentUserId
        listenForMessages()
    }

    deinit {
        listener?.remove()
    }

    private func listenForMessages() {
        listener = db.collection("connections")
            .document(connectionId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self?.messages = documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                }
            }
    }

    func sendMessage(text: String) {
        let message = Message(
            senderId: currentUserId,
            type: "text",
            content: text,
            timestamp: Date()
        )

        do {
            _ = try db.collection("connections")
                .document(connectionId)
                .collection("messages")
                .addDocument(from: message)
        } catch {
            print("Error sending message: \(error)")
        }
    }
}
