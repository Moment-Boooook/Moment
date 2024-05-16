//
//  UpdateUserNameFeature.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import Foundation

import ComposableArchitecture

// MARK: - UpdateUserNameView Reducer
@Reducer
struct UpdateUserNameFeature {
    
    @ObservableState
    struct State: Equatable {
        @ObservationStateIgnored
        @Shared var userName: String
        
        var changedName: String = ""
        var isCompleted: Bool {
            !changedName.isEmpty
        }
        var focusedField: Bool = true
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case clearFocusState
        case clearName
        case closeSheet
        case setName(String)
        case updateUserName(String)
    }
    
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            //
            case .binding:
                return .none
            // clear FocusState
            case .clearFocusState:
                state.focusedField = false
                return .none
            // clear Name TextField
            case .clearName:
                state.changedName = ""
                return .none
            // sheet cancel
            case .closeSheet:
                return .run { _ in
                    await self.dismiss()
                }
            // setName + trimWhiteSpace
            case let .setName(newName):
                state.changedName = newName.trimWhiteSpace()
                return .none
            case let .updateUserName(newName):
                state.userName = newName
                return .run { send in
                    await send(.closeSheet)
                }
            }
        }
    }
}
