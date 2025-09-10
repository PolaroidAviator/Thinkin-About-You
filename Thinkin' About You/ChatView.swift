//
//  ChatView.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/6/25.
//


import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var newMessage = ""

    init(connectionId: String, currentUserId: String) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(connectionId: connectionId, currentUserId: currentUserId))
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.senderId == viewModel.currentUserId {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue.opacity(0.8))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            HStack {
                TextField("Message...", text: $newMessage)
                    .textFieldStyle(.roundedBorder)
                Button("Send") {
                    guard !newMessage.isEmpty else { return }
                    viewModel.sendMessage(text: newMessage)
                    newMessage = ""
                }
            }
            .padding()
        }
        .navigationTitle("Chat")          // Title at top
        .navigationBarTitleDisplayMode(.inline)
    }
}
