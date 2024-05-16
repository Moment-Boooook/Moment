//
//  AppStartFeature.swift
//  Moment
//
//  Created by phang on 3/28/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - Splash + Onboarding View Reducer
@Reducer
struct AppStartFeature {
    
    @ObservableState
    struct State: Equatable {
        @ObservationStateIgnored
        @Shared var books: [MomentBook]
        @ObservationStateIgnored
        @Shared var records: [MomentRecord]
        
        // splash
        var isAppStarting: Bool = true
        var appLogoDegreeChange: Bool = false
        // onboarding
        var isOnboardingCompleted: Bool = false
        var currentOnboardingPage: OnboardingPage = .first
        let onboardingData: [OnboardingData] = [
            OnboardingData(page: .first),
            OnboardingData(page: .second),
            OnboardingData(page: .last)
        ]
        // name setting
        var isSetName: Bool = false
        var name: String = ""
        var focusedField: Bool = true
        let maxLength = 12
        
        mutating func fetchBooks() {
            @Dependency(\.swiftDataService) var swiftData
            do {
                self.books = try swiftData.fetchBookList()
            } catch {
                print("error :: fetchBooks", error.localizedDescription)
            }
        }
        
        mutating func fetchRecords() {
            @Dependency(\.swiftDataService) var swiftData
            do {
                self.records = try swiftData.fetchRecordList()
            } catch {
                print("error :: fetchRecords", error.localizedDescription)
            }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        // splash
        case appStart
        case degreeChange
        case fetchAllData
        case fetchBooks
        case fetchRecords
        case fetchOnboardingCompleted
        case quitSplash
        // onboarding
        case nextPage
        case setPage(OnboardingPage)
        case setPageIndicator(Color)
        case startButtonTapped
        // name setting
        case completeOnboardingAndSetName
        case refetchCompleteOnboardingAndSetName
        case saveName
        case setName(String)
    }
    
    // Cancellable 에서 사용할 enum
    enum CancelID { case timer }
    
    @Dependency(\.commons) var commons
    @Dependency(\.continuousClock) var clock
    @Dependency(\.naverBookService) var naverBookService
    
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            //
            case .binding:
                return .none
            // MARK: - Splah
            // App 시작 시,
            case .appStart:
                return .merge(
                    .run { send in
                        await send(.degreeChange)
                    },
                    .run { send in
                        await send(.fetchAllData)
                        // TODO: - 표지 정보 업데이트
                        await send(.fetchOnboardingCompleted)
                    }
                )
            // 애니메이션 각도 변경
            case .degreeChange:
                withAnimation(.easeOut(duration: 1.75)) {
                    state.appLogoDegreeChange = true
                }
                return .none
            // fetchBooks + fetchRecords
            case .fetchAllData:
                return .merge(
                    .run { send in
                        await send(.fetchBooks)
                    },
                    .run { send in
                        await send(.fetchRecords)
                    }
                )
            // 유저의 책 fetch
            case .fetchBooks:
                state.fetchBooks()
                return .none
            // 유저의 기록 fetch
            case .fetchRecords:
                state.fetchRecords()
                return .none
            // 온보딩 완료 여부 fetch - appstorage
            case .fetchOnboardingCompleted:
                let isCompleted = commons.isCompleteOnboardingAndSetName()
                state.isOnboardingCompleted = isCompleted
                state.isSetName = isCompleted
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1.75)) {
                        await send(.quitSplash)
                    }
                }
                .cancellable(id: CancelID.timer)
            // 스플래쉬 뷰 닫기
            case .quitSplash:
                state.isAppStarting = false
                return .cancel(id: CancelID.timer)
                
            // MARK: - Onboarding
            // 다음 온보딩 페이지
            case .nextPage:
                withAnimation {
                    if state.currentOnboardingPage == .first {
                        state.currentOnboardingPage = .second
                    } else if state.currentOnboardingPage == .second {
                        state.currentOnboardingPage = .last
                    }
                }
                return .none
            // 페이지 세팅
            case let .setPage(page):
                state.currentOnboardingPage = page
                return .none
            // onboarding 페이지 스타일 탭뷰 인디케이터 색상 변경
            case let .setPageIndicator(color):
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(color)
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
                return .none
            // 시작하기 버튼 탭
            case .startButtonTapped:
                state.isOnboardingCompleted = true
                return .none
            // MARK: - Name Setting
            // onboarding 완료
            case .completeOnboardingAndSetName:
                commons.completeOnboardingAndSetName()
                return .none
            // 온보딩 완료 여부 refetch - appstorage
            case .refetchCompleteOnboardingAndSetName:
                state.isSetName = commons.isCompleteOnboardingAndSetName()
                return .none
            // 저장 버튼 탭
            case .saveName:
                // TODO: - 이름 저장해줘야 함
                return .concatenate(
                    .run { send in
                        await send(.completeOnboardingAndSetName)
                    },
                    .run { send in
                        await send(.refetchCompleteOnboardingAndSetName)
                    }
                )
            // 이름 설정
            case let .setName(name):
                state.name = name
                return .none
            }
        }
    }
}
