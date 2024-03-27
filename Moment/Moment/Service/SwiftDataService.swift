//
//  SwiftDataService.swift
//  Moment
//
//  Created by phang on 3/27/24.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

// MARK: - Swift Data 에 데이터 주고 받는 Service
struct SwiftDataService {
    @Query private var bookList: [MomentBook]
    @Query private var recordList: [MomentRecord]
    
    var bookListFetch: () throws -> [MomentBook]

    enum SwiftDataError: Error {
        case fetchError
        case addError
        case deleteError
    }
}

extension SwiftDataService: DependencyKey {
    static let liveValue = Self(
        // Book List Fetch
        bookListFetch: {
            do {
                @Dependency(\.databaseService.context) var context
                let bookListContext = try context()
                let descriptor = FetchDescriptor<MomentBook>(sortBy: [SortDescriptor(\.bookISBN)])
                return try bookListContext.fetch(descriptor)
            } catch {
                throw SwiftDataError.fetchError
            }
        }
    )
}
