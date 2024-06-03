//
//  AppLocalized.swift
//  Moment
//
//  Created by phang on 5/17/24.
//

import Foundation

// MARK: - NameSpace
enum AppLocalized {
    // App
    static let appName = "Moment"
    static let appSubTitle = "그 날, 그 곳, 그 구절"
    static let productionInfo = """
                                2023, Moment all rights reserved.
                                Powered by PJ2T3_BOOOOOK
                                """
    //
    static let startButton = "시작하기"
    static let nextButton = "다음"
    static let saveButton = "저장하기"
    static let deleteButton = "삭제하기"
    static let okButton = "확인"
    static let backTextButton = "돌아가기"
    static let changeButton = "변경 완료"
    static let disableRecordSaveButton = "아직 다 작성되지 않았어요"
    static let recordSaveButton = "기억 저장하기"
    static let photosPickGuide = "불러올 사진 위치를 선택해주세요"
    static let cameraButton = "카메라"
    static let libraryButton = "라이브러리"
    static let locationSaveButton = "이 위치로 설정하기"
    static let dataBackUpButton = "데이터 백업하기"
    static let dataRestoreButton = "데이터 복원하기"
    static let aboutMomentButton = "Moment 알아보기"
    static let openSourceButton = "오픈라이선스"
    
    static let onboardingContent01 = "모멘트와 함께\n기억 속에 남겨두고 싶은\n책의 내용을 기록해보세요."
    static let onboardingContent02 = "모멘트와 함께\n어디서 읽었는지\n기억하고 싶지 않으신가요?"
    static let onboardingContent03 = "모멘트와 함께\n기록하여 여러분만의\n책장을 완성시켜 보아요!"
    
    static let bookLottie = "book"
    static let loadingLottie = "loading"
    
    static let localID = "ko-KR"
    static let moreThanHundred = "99+"

    static let setNameGuideTitle = "사용할 이름을 등록해주세요!"
    static let setNameGuide = "이름은 언제든 변경할 수 있어요"
    static let setName = "이름 설정"
    static let setNameRule = "자 이내"
    static let searchBookTitle = "책 제목 검색"
    static let emptyBookShelfMessage = """
                                        님,
                                        책장이 비어있어요.
                                        기억 속에 책을 남겨보세요.
                                        """
    static let bookSearchResult = "책 검색 결과"
    static let bookSearchEmptyResult = "책 검색 결과가 없어요."
    static let bookLeftInMemory = "기억에 남겨진 책"
    static let addBookTitle = "기억하고 싶은 책 선택하기"
    static let setCurrentLocation = "현재 위치"
    static let locationAliasSetGuide = "위치를 기억할 이름을 지어주세요."
    static let setParagraph = "기억할 내용"
    static let paragraphSetGuide = "책에서 기억하고자 하는 문장을 적어주세요."
    static let pageSetGuide = "해당 문장이 있는 페이지를 적어주세요."
    static let photoSet = "사진 등록"
    static let photoSetLimitGuide = "(최대 3장)"
    static let photoSetGuide = "사진을 등록하세요!"
    static let author = "지은이"
    static let publisher = "출판사"
    static let plot = "줄거리"
    static let page = "페이지"
    static let recordMemory = " 에서의 기억이에요"
    static let year = "년"
    static let change = "변경"
    static let dataTitle = "데이터"
    static let dataSubTitle = """
                            Moment 의 기억을 파일로 백업하여
                            새로운 기기로 옮길 수 있어요
                            """
    static let appInfoTitle = "앱 정보"
    static let appVersionTitle = "Moment 버전"
    static let appVersionSubTitle = "버전 정보"
    static let settingTitle = "설정"
    
    static let saveRecordAlertText = "저장된 기억은 수정할 수 없어요...🥲"
    static let deleteRecordAlertText = "기억을 삭제할까요?"
    static let dataRestoreAlertText = """
                                    복원 시엔 기존 데이터가 사라지니
                                    백업을 먼저 추천드려요!
                                    """
    static let compressFailAlertText = """
                                    백업을 위한 파일 생성에 실패했어요
                                    다시 한번 시도해주세요!
                                    """    
    static let decompressFailAlertText = """
                                    데이터 복원에 실패했어요
                                    다시 한번 시도해주세요!
                                    """
    static let updateNameTitle = "수정할 닉네임을 작성해주세요"
    static let nameTitle = "수정할 닉네임을 작성해주세요"
    
    // Bundle Version
    static let versionKey = "CFBundleShortVersionString"
    static let buildKey = "CFBundleVersion"
    
    // AppStorage
    static let onboardingAndSetNameAppStorageData = "isOnboardingAndSetName"
    
    // FileManager & Compressed File
    static let fileType = ".moment"
    static let fileDescription = "Moment backup file"
    static let customActivityType = "com.hrmi.Moment.customActivity"
    
    // SwiftData
    static let storeFile = "default.store"
    static let shmFile = "default.store-shm"
    static let walFile = "default.store-wal"
    
    // time
    static let nanosecondPointOne: UInt64 = 100_000_000
    
    // image
    static let appIcon = "AppIcon"
    static let logoBooks = "pieces"
    static let logoBook = "lastPiece"
    static let onboardingImage01 = "onboarding01"
    static let onboardingImage02 = "onboarding02"
    static let onboardingImage03 = "onboarding03"
    static let defaultImage = "defaultImage"
    
    static let searchImage = "magnifyingglass"
    static let xImage = "xmark"
    static let settingImage = "gearshape.fill"
    static let plusImage = "plus"
    static let beforeImage = "chevron.left"
    static let rightImage = "chevron.right"
    static let mapImage = "map"
    static let photoImage = "photo"
    static let locationImage = "location"
    static let infoImage = "info.circle"
    static let trashImage = "trash"
}
