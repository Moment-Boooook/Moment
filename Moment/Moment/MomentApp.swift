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
	static let store = Store(initialState: SplashFeature.State()) {
		SplashFeature()
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
			if MomentApp.store.isActive {
//				SplashView(isActive: $isLoading)
				SplashView(store: MomentApp.store)
			} else {
				ContentView()
					.modelContainer(sharedModelContainer)
			}
		}
	}
}
