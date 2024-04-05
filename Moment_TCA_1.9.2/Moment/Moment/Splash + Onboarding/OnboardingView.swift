//
//  OnboardingView.swift
//  Moment
//
//  Created by phang on 12/11/23.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Onboarding View
struct OnboardingView: View {
    let store: StoreOf<AppStartFeature>
    
    private let onboardingData: [OnboardingData] = [
        OnboardingData(content: "모멘트와 함께\n기억 속에 남겨두고 싶은\n책의 내용을 기록해보세요.", image: "onboarding01"),
        OnboardingData(content: "모멘트와 함께\n어디서 읽었는지\n기억하고 싶지 않으신가요?", image: "onboarding02"),
        OnboardingData(content: "모멘트와 함께\n기록하여 여러분만의\n책장을 완성시켜 보아요!", image: "onboarding03")
    ]
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            // 뷰
            VStack(alignment: .center, spacing: 30) {
                // 탭뷰
                TabView {
                    ForEach(onboardingData) { data in
                        OnboardingCardView(onboarding: data, size: size.width / 4 * 3)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                // 버튼
                Button {
                    store.send(.startButtonTapped)
                } label: {
                    Text("시작하기")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.capsuled(color: .mainBrown, width: size.width / 5 * 3))
            }
            // TabView - Page Indicator Color 수정
            .onAppear {
                store.send(.setPageIndicator(.mainBrown))
            }
        }
    }
}

// MARK: - Onboarding Card View
private struct OnboardingCardView: View {
    let onboarding: OnboardingData
    let size: CGFloat
    
    fileprivate var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(onboarding.content)
                .font(.title)
                .foregroundStyle(.mainBrown)
            
            Image(onboarding.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size)
        }
    }
}

// MARK: - Onboarding 에서 사용되는 이미지와 텍스트 내용을 가질 구조체
private struct OnboardingData: Identifiable {
    var id = UUID()
    var content: String
    var image: String
}

#Preview {
    OnboardingView(
        store: Store(
            initialState: AppStartFeature.State()
        ) {
            AppStartFeature()
        }
    )
}
