//
//  MomentApp.swift
//  Moment
//
//  Created by phang on 12/11/23.
//

import SwiftUI
import SwiftData

import ComposableArchitecture

@main
struct MomentApp: App {
    // TCA
    static let store = Store(initialState: AppContentViewFeature.State()) {
        AppContentViewFeature()
            ._printChanges()
    }
    
	var body: some Scene {
		WindowGroup {
            AppContentView(store: MomentApp.store)
                .modelContainer(for: [
                    MomentUser.self,
                    MomentRecord.self,
                    MomentBook.self
                ])
		}
	}
}
