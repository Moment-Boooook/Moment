//
//  AppStartView.swift
//  Moment
//
//  Created by phang on 3/28/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Splash / Onboarding View
struct AppStartView: View {
    @Bindable var store: StoreOf<AppStartFeature>
    
    var body: some View {
        VStack {
            if store.isAppStarting {
                SplashView(store: store)
            } else if !store.isOnboardingCompleted {
                OnboardingView(store: store)
            } else {
                NameSettingView(store: store)
            }
        }
    }
}

#Preview {
    AppStartView(
        store: Store(
            initialState: AppStartFeature.State(userName: Shared(""),
                                                books: Shared([]),
                                                records: Shared([]))
        ) {
            AppStartFeature()
        }
    )
}
