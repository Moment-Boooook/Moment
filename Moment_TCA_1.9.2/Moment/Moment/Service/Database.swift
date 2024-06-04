//
//  Database.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import Foundation
import SwiftData

import ComposableArchitecture

// MARK: - Model Context
fileprivate let modelContext: ModelContext = {
    let schema = Schema([
        MomentUser.self,
        MomentBook.self,
        MomentRecord.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema,
                                                isStoredInMemoryOnly: false)
    do {
        let container = try ModelContainer(for: schema,
                                           configurations: [modelConfiguration])
        return ModelContext(container)
    } catch {
        fatalError("Could not create ModelContainer: \(error.localizedDescription)")
    }
}()

// MARK: - SwiftData 사용 Database
struct Database {
    var context: () throws -> ModelContext
}

extension Database: DependencyKey {
    public static let liveValue = Self(
        context: {
            modelContext
        }
    )
}

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // Database
    var databaseService: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
}
