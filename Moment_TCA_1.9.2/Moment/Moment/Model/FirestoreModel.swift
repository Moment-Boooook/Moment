//
//  FirestoreModel.swift
//  Moment
//
//  Created by phang on 5/4/24.
//

import Foundation

import FirebaseFirestore

// MARK: - Firestore : User
struct User: Codable {
    @DocumentID var UDID: String?
    var name: String
}
