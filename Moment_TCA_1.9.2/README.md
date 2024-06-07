

# Moment:  그 날, 그 곳, 그 구절
<img width="240" height="240" border:0px src="https://github.com/APP-iOS3rd/PJ2T3_Boooook/assets/103061387/f5665848-b4f4-4e48-a69b-3a50d1f1f766"/>

## 팀 소개

  ||||||
  | :-----: | :-----: | :-----: | :-----: | :-----: |
  |<img width="120" height="120" border:0px src="https://avatars.githubusercontent.com/u/103061387?v=4"/>|<img width="120" height="120" border:0px src="https://avatars.githubusercontent.com/u/80156515?v=4"/>|<img width="120" height="120" border:0px src="https://avatars.githubusercontent.com/u/75058050?v=4"/>|<img width="120" height="120" border:0px src="https://avatars.githubusercontent.com/u/109324421?v=4"/>|<img width="120" height="120" border:0px src="https://avatars.githubusercontent.com/u/120158212?v=4"/>|
  |[홍세희](https://github.com/SAY-Hong)|[김민재](https://github.com/bdrsky2010)|[백대홍](https://github.com/DevLarva)|[이창준](https://github.com/Phangg)|[정인선](https://github.com/withseon)|

<br>


## 📚Moment는,
![Vectary_texture](https://github.com/APP-iOS3rd/PJ2T3_Boooook/assets/75058050/a80f25bb-5e3e-4985-a7e6-9834b03bba93)

안녕하세요.  ‘**Moment:  그 날, 그 곳, 그 구절’** 앱은

책을 기록한  ‘**날**’은 언제인지,

내가 어느 ‘**곳**’에서 그 책에 대한 기록을 남겼는지,

내가 인상깊게 읽은 책의 ‘**구절**’은 무엇인지,

나만의 책장에 저장하고 나만의 지도에서 기록이 남겨진 곳이 어디인지 확인할 수 있는 앱입니다. 

<br>
<br>

🔗**더 자세히 알아보기**
- [Moment 프로젝트 노션](https://glacier-coneflower-d58.notion.site/Moment-f97396505f86478a8d26c25d891b91cf?pvs=4)
- [Figma](https://www.figma.com/file/1UzNLAqUxy6OkCSJ9lNxID/BOOOOOK?type=design&node-id=0%3A1&mode=design&t=NiwmFAYS2dh1v3IH-1)
<br>

## 📚Moment를 소개합니다.

### 1. Splash View 와 온보딩 화면

- 앱 시작 시, Splash View로 <**Moment:  그 날, 그 곳, 그 구절**>의 앱 아이콘을 보여주고
      OnBoarding 화면을 통해 앱을 사용하는 방법을 간단하게 보여줍니다. 
        
![234shots_so](https://github.com/APP-iOS3rd/PJ2T3_Boooook/assets/75058050/146a4765-6f44-4695-817f-c36dd878de79)



### 2. 나만의 책장 및 나만의 지도



 




   - 나만의 책장
        - ‘나만의 책장’에서 기록된 책을 보여주고 기록된 책을 누르면 사용자가 작성한 책에 해당하는 기록을 연도별로 보여줍니다.
![114shots_so](https://github.com/APP-iOS3rd/PJ2T3_Boooook/assets/75058050/c8fd26fa-407f-4e01-af14-c562285abdb1)

    




    
   - 나만의 지도
        - ‘내 지도’에서 어느 장소에서 독서기록을 추가했는지 확인해볼 수 있습니다.
        - 지도에 뜬 독서 기록을 눌러서 그 장소에서 기록한 모든 내역을 책 제목을 기준으로 확인할 수 있습니다.  
![691shots_so](https://github.com/APP-iOS3rd/PJ2T3_Boooook/assets/75058050/0f8a5f39-dce9-432e-9f5f-b07dee80b563)

    








### 3. 독서 기록
 - Naver 도서 API를 이용한 독서 기록장
    - 기억하고 싶은 장소, 인용구를 함께 작성하여 그 날, 그 곳, 그 장소를 기록해보세요.   

![337shots_so](https://github.com/APP-iOS3rd/PJ2T3_Boooook/assets/75058050/0b67ec17-8bdf-4947-85c2-47c047f2da49)


---


### 앱 개발 환경 및 주요 스택
- Xcode Version 15.1 (15A507)
- SwiftUI, iOS 17.0
- API: Naver 도서 검색

### 프레임워크
- MapKit
- SwiftData
- [Kingfisher](https://github.com/onevcat/Kingfisher) [ * refactoring 시, 적용 ]
- [Lottie](https://github.com/airbnb/lottie-ios) [ * refactoring 시, 적용 ]
- [ZIPFoundation](https://github.com/weichsel/ZIPFoundation) [ * refactoring 시, 적용 ]
- [TCA](https://github.com/pointfreeco/swift-composable-architecture) [ * refactoring 시, 적용 ]

---


## 리팩토링 - [ 2024.03.28 ~  ]
- 참여: [이창준](https://github.com/Phangg)

## AppStore Link
- [ Moment - 모멘트 ](https://apps.apple.com/kr/app/moment-%EB%AA%A8%EB%A9%98%ED%8A%B8/id6503728275)

### 리팩토링 내용
- [TCA](https://github.com/pointfreeco/swift-composable-architecture) 아키텍처 적용 (1.9.2 버전)
- 불필요 코드 및 오탈자 / 오류 및 로직 일부분 수정
- 일부 뷰 추가 및 수정
- 추가 기능 구현
- TDD 코드 작성
- [Kingfisher](https://github.com/onevcat/Kingfisher) 라이브러리 적용
- 로컬 데이터 복원 / 복구 기능 적용 ( [ZIPFoundation](https://github.com/weichsel/ZIPFoundation) 활용 )
