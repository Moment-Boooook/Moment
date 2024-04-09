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
    var recordListFetch: () throws -> [MomentRecord]
    var addBook: (MomentBook) throws -> Void
    var addRecord: (MomentRecord) throws -> Void
    var deleteBook: (MomentBook) throws -> Void
    var deleteRecord: (MomentRecord) throws -> Void

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
        },
        // Add Book
        addBook: { book in
            do {
                @Dependency(\.databaseService.context) var context
                let bookContext = try context()
                bookContext.insert(book)
            } catch {
                throw SwiftDataError.addError
            }
        },
        // Add Record
        addRecord: { record in
            do {
                @Dependency(\.databaseService.context) var context
                let recordContext = try context()
                recordContext.insert(record)
            } catch {
                throw SwiftDataError.addError
            }
        },
        // Delete Book
        deleteBook: { book in
            do {
                @Dependency(\.databaseService.context) var context
                let bookContext = try context()
                bookContext.delete(book)
            } catch {
                throw SwiftDataError.deleteError
            }
        },
        // Delete Record
        deleteRecord: { record in
            do {
                @Dependency(\.databaseService.context) var context
                let recordContext = try context()
                recordContext.delete(record)
            } catch {
                throw SwiftDataError.deleteError
            }
        }
    )
}
