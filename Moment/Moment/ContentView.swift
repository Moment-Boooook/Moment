//
//  ContentView.swift
//  Moment
//
//  Created by phang on 12/11/23.
//


import SwiftUI
import ComposableArchitecture

struct ContentView: View {
	let store: StoreOf<RootFeature>
	
    var body: some View {
		if store.scope(state: \.onboarding, action: \.onboarding).isOnboardingCompleted {
			OnboardingMainView(store: store.scope(state: \.onboarding, action: \.onboarding))
        } else {
			MainView()
        }
    }
}
