//
//  OnboardingMainView.swift
//  Moment
//
//  Created by phang on 12/11/23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Onboarding DATA MODEL
struct OnboardingData: Identifiable, Equatable {
	var id = UUID()
	var title: String
	var image: String
}

struct OnboardingMainView: View {
	let store: StoreOf<OnBoardingFeature>
    
    var body: some View {
        VStack {
            TabView {
				ForEach(store.onboardings) { item in
                    OnboardingCardView(onboarding: item)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .padding(.vertical, 20)
            .onAppear {
				store.send(.setupAppearance)
            }
			
			Button {
				store.send(.completeOnboarding)
			} label: {
				HStack(spacing: 8) {
					Text("시작하기")
						.foregroundStyle(Color.white)
				}
				.frame(width: 240, height: 50)
				.background(.mainBrown)
				.cornerRadius(24)
			}
        }
    }
}

private struct OnboardingCardView: View {
	var onboarding: OnboardingData
	
	var body: some View {
		VStack(alignment: .center) {
			Text(onboarding.title)
				.font(.title)
				.foregroundStyle(Color.mainBrown)
			
			Image(onboarding.image)
				.resizable()
				.frame(width: 296, height: 449)
				.padding()
		}
	}
}

#Preview {
	OnboardingMainView(
		store: Store(initialState: OnBoardingFeature.State()) {
			OnBoardingFeature()
		})
}
