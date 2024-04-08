//
//  DependencyValues +.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // Commons
    var commons: Commons {
        get { self[Commons.self] }
        set { self[Commons.self] = newValue }
    }

    // Database
    var databaseService: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
    
    // SwiftData Service
    var swiftDataService: SwiftDataService {
        get { self[SwiftDataService.self] }
        set { self[SwiftDataService.self] = newValue }
    }
    
    // Naver Book API Service
    var naverBookService: NaverBookAPIService {
        get { self[NaverBookAPIService.self] }
        set { self[NaverBookAPIService.self] = newValue }
    }
    
    // CLLocation Service
    var locationManagerService: LocationManagerService {
        get { self[LocationManagerService.self] }
        set { self[LocationManagerService.self] = newValue }
    }
}