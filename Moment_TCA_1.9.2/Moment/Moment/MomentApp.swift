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
    static let store = Store(initialState: AppContentViewFeature.State()) {
        AppContentViewFeature()
            ._printChanges()
    }
    
	var body: some Scene {
		WindowGroup {
            AppContentView(store: MomentApp.store)
                .modelContainer(for: [
                    MomentRecord.self, MomentBook.self
                ])
		}
	}
}
