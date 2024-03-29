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
    var sortedByTitleBookListFetch: () throws -> [MomentBook]
    var recordListFetch: () throws -> [MomentRecord]

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
                let descriptor = FetchDescriptor<MomentBook>()
                return try bookListContext.fetch(descriptor)
            } catch {
                throw SwiftDataError.fetchError
            }
        },
        // Book List Fetch ( 책 제목 순서 정렬 )
        sortedByTitleBookListFetch: {
            do {
                @Dependency(\.databaseService.context) var context
                let bookListContext = try context()
                let descriptor = FetchDescriptor<MomentBook>(sortBy: [SortDescriptor(\.title)])
                return try bookListContext.fetch(descriptor)
            } catch {
                throw SwiftDataError.fetchError
            }
        },
        // Record List Fetch
        recordListFetch: {
            do {
                @Dependency(\.databaseService.context) var context
                let recordListContext = try context()
                let descriptor = FetchDescriptor<MomentRecord>()
                return try recordListContext.fetch(descriptor)
            } catch {
                throw SwiftDataError.fetchError
            }
        }
    )
}
