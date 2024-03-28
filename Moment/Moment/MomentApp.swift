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
	static let store = Store(initialState: AppFeature.State()) {
		AppFeature()
	}
	@State private var isLoading = true
	
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			MomentRecord.self, MomentBook.self
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
	var body: some Scene {
		WindowGroup {
			if MomentApp.store.splash.isActive {
				SplashView(store: MomentApp.store.scope(state: \.splash, action: \.splash))
			} else {
				ContentView(store: MomentApp.store.scope(state: \.root, action: \.root))
					.modelContainer(sharedModelContainer)
			}
		}
	}
}
