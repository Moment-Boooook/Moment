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
    static let store = Store(initialState: HomeViewFeature.State()) {
        HomeViewFeature()
            ._printChanges()
    }
	
	var body: some Scene {
		WindowGroup {
            HomeView(store: MomentApp.store)
                .modelContainer(for: [
                    MomentRecord.self, MomentBook.self
                ])
		}
	}
}
