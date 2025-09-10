//
//  Message.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/6/25.
//


import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var id: String?   // Firestore auto-generates this
    var senderId: String
    var type: String              // "text", "tap", "color"
    var content: String
    var timestamp: Date
}
