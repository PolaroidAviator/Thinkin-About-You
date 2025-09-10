//
//  PairingView.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/5/25.
//

import SwiftUI

struct PairingView: View {
    @EnvironmentObject var session: SessionManager
    @State private var generatedCode: String?
    @State private var inputCode = ""
    @State private var status: String?
    @State private var navigateToChat = false
    @State private var connectionId: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Pair with someone")
                    .font(.title2)
                    .bold()

                Button("Generate Code") {
                    guard let uid = session.userId else { return }
                    PairingService.shared.generateCode(ownerUid: uid) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let code):
                                generatedCode = code
                                status = "Share this code!"
                            case .failure(let err):
                                status = "Error: \(err.localizedDescription)"
                            }
                        }
                    }
                }

                if let code = generatedCode {
                    Text(code)
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                }

                Divider()

                HStack {
                    TextField("Enter code", text: $inputCode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    Button("Join") {
                        guard let uid = session.userId else { return }
                        PairingService.shared.join(code: inputCode, joinerUid: uid) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let connId):
                                    status = "Paired! Connection ID: \(connId)"
                                    connectionId = connId
                                    navigateToChat = true
                                case .failure(let err):
                                    status = "Error: \(err.localizedDescription)"
                                }
                            }
                        }
                    }
                    .disabled(inputCode.count != 6)
                }

                if let status = status {
                    Text(status)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .padding()
            // Modern navigationDestination API
            .navigationDestination(isPresented: $navigateToChat) {
                if let connId = connectionId, let uid = session.userId {
                    ChatView(connectionId: connId, currentUserId: uid)
                }
            }
        }
    }
}
