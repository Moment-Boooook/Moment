//
//  AppContentView.swift
//  Moment
//
//  Created by phang on 12/11/23.
//

import SwiftUI

import ComposableArchitecture

// MARK: - App Content View
struct AppContentView: View {
    @Bindable var store: StoreOf<AppContentViewFeature>
    
    var body: some View {
        // app 시작 splash view
        if store.appStart.isAppStarting ||
            !store.appStart.isOnboardingCompleted ||
            !store.appStart.isSetName {
            AppStartView(store: store.scope(state: \.appStart, action: \.appStart))
        } else {
            HomeView(store: store.scope(state: \.home, action: \.home))
        }
    }
}
