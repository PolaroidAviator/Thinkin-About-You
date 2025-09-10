//
//  PairingService.swift
//  Thinkin' About You
//
//  Created by Connor Cain on 9/5/25.
//


import Foundation
import FirebaseFirestore

final class PairingService {
    static let shared = PairingService()
    private let db = Firestore.firestore()

    func generateCode(ownerUid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let code = String(format: "%06d", Int.random(in: 0...999999))
        let ref = db.collection("pairingCodes").document(code)

        ref.setData([
            "ownerUid": ownerUid,
            "createdAt": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(code))
            }
        }
    }

    func join(code: String, joinerUid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let codeRef = db.collection("pairingCodes").document(code)

        codeRef.getDocument { doc, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = doc?.data(),
                  let ownerUid = data["ownerUid"] as? String else {
                completion(.failure(NSError(domain: "Pairing", code: 404,
                                            userInfo: [NSLocalizedDescriptionKey: "Code not found"])))
                return
            }

            let connRef = self.db.collection("connections").document()
            connRef.setData([
                "users": [ownerUid, joinerUid],
                "createdAt": FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    codeRef.delete()
                    completion(.success(connRef.documentID))
                }
            }
        }
    }
}