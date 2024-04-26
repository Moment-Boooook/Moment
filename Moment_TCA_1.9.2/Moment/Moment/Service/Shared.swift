//
//  GlobalDataService.swift
//  Moment
//
//  Created by phang on 4/26/24.
//

import Foundation

import ComposableArchitecture

// MARK: - 데이터를 공유하기 위함
@Observable
@propertyWrapper
final class Shared<Value> {
    var wrappedValue: Value
    
    init(_ value: Value) {
        self.wrappedValue = value
    }
}

extension Shared: Equatable where Value: Equatable {
    static func == (lhs: Shared, rhs: Shared) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
