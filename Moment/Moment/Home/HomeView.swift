//
//  HomeView.swift
//  Moment
//
//  Created by phang on 12/11/23.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    @AppStorage("firstTimeUser") var firstTimeUser: Bool = true
    let store: StoreOf<HomeViewFeature>
    
    var body: some View {
        if store.splash.isAppStarting {
            SplashView(store: store.scope(state: \.splash, action: \.splash))
        } else if firstTimeUser {
            OnboardingView(store: store.scope(state: \.onboarding, action: \.onboarding))
        } else {
//            MainView()
            Text("Main")
        }
    }
}
