//
//  FirestoreService.swift
//  Moment
//
//  Created by phang on 5/4/24.
//

import Foundation

import ComposableArchitecture
import FirebaseCore
import FirebaseFirestore

// MARK: - Firesore Database Service
struct FirestoreService {
    private static let db = Firestore.firestore()
    private static let userCollection = "user"
    
    var signInUser: (User, String) async throws -> Result<Bool, Error>
}

extension FirestoreService: DependencyKey {
    static let liveValue = Self(
        signInUser: { (userData, id) in
            do {
                try db.collection(userCollection).document(id).setData(from: userData)
                return Result.success(true)
            } catch {
                dump(error)
                print("error :: signInUser", error.localizedDescription)
                return Result.failure(error)
            }
        }
    )
}

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // Firesore Database Service
    var firestoreService: FirestoreService {
        get { self[FirestoreService.self] }
        set { self[FirestoreService.self] = newValue }
    }
}
