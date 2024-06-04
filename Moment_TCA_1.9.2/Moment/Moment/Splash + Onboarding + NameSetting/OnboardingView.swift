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
    @Bindable var store: StoreOf<AppStartFeature>
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            // 뷰
            VStack(alignment: .center, spacing: 30) {
                // 탭뷰
                TabView(selection: $store.currentOnboardingPage.sending(\.setPage)) {
                    ForEach(store.onboardingData) { data in
                        OnboardingCardView(onboarding: data, size: size.width / 4 * 3)
                            .tag(data.page)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                // 버튼
                Button {
                    if store.currentOnboardingPage == .third {
                        store.send(.startButtonTapped)
                    } else {
                        store.send(.nextPage)
                    }
                } label: {
                    if store.currentOnboardingPage == .third {
                        Text(AppLocalized.startButton)
                            .font(.medium16)
                            .foregroundStyle(.white)
                    } else {
                        Text(AppLocalized.nextButton)
                            .font(.medium16)
                            .foregroundStyle(.white)
                    }
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
struct OnboardingData: Identifiable, Hashable {
    var id = UUID()
    var page: OnboardingPage
    var content: String { page.content }
    var image: String { page.image }
}

enum OnboardingPage {
    case first
    case second
    case third
    
    var content: String {
        switch self {
        case .first:
            AppLocalized.onboardingContent01
        case .second:
            AppLocalized.onboardingContent02
        case .third:
            AppLocalized.onboardingContent03
        }
    }
    
    var image: String {
        switch self {
        case .first:
            AppLocalized.onboardingImage01
        case .second:
            AppLocalized.onboardingImage02
        case .third:
            AppLocalized.onboardingImage03
        }
    }
}

#Preview {
    OnboardingView(
        store: Store(
            initialState: AppStartFeature.State(userName: Shared(.empty),
                                                books: Shared([]),
                                                records: Shared([]),
                                                currentOnboardingPage: .first)
        ) {
            AppStartFeature()
        }
    )
}
