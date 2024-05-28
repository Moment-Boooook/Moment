//
//  ActivityView.swift
//  Moment
//
//  Created by phang on 5/22/24.
//

import LinkPresentation
import SwiftUI

import ComposableArchitecture

// MARK: - ActivityView ( SharePanel )
struct ActivityView: UIViewControllerRepresentable {
    @Bindable var store: StoreOf<SettingViewFeature>
    
    func makeUIViewController(
        context: Context
    ) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {
        let activityViewController = UIActivityViewController(
            activityItems: store.activityItem?.items ?? [],
            applicationActivities: store.activityItem?.activities)
        if store.isActivityViewPresented,
           uiViewController.presentedViewController == nil {
            uiViewController.present(activityViewController, animated: true)
        }
        activityViewController.completionWithItemsHandler = { (_, _, _, _) in
            store.send(.closeActivityView)
        }
    }
}

// MARK: - ActivityItem in ActivityView
struct ActivityItem: Equatable {
    var items: [ActivityItemSource]
    var activities: [UIActivity]?
    var excludedTypes: [UIActivity.ActivityType]
    
    static func == (lhs: ActivityItem, rhs: ActivityItem) -> Bool {
        lhs.activities == rhs.activities
    }
    
    // items: `UIActivityViewController` 를 통해 공유할 아이템
    // activities: 시트에 포함시키고자 하는 커스텀 `UIActivity`
    init(
        items: [ActivityItemSource],
        activities: [UIActivity]? = nil,
        excludedTypes: [UIActivity.ActivityType] = []
    ) {
        self.items = items
        self.activities = activities
        self.excludedTypes = excludedTypes
    }
}

// MARK: - Custom ActivityItemSource
final class ActivityItemSource: NSObject, UIActivityItemSource {
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        return url
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return url
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return AppLocalized.fileDescription
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        thumbnailImageForActivityType activityType: UIActivity.ActivityType?,
        suggestedSize size: CGSize
    ) -> UIImage? {
        return UIImage(named: AppLocalized.appIcon) ?? UIImage()
    }
    
    func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController)
    -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.iconProvider = NSItemProvider(
            object: UIImage(named: AppLocalized.appIcon) ?? UIImage())
        metadata.title = url.lastPathComponent
        let size = url.formattedFileSize()
        let type = AppLocalized.fileDescription
        let subtitleString = "\(type) \(size)"
        metadata.originalURL = URL(fileURLWithPath: subtitleString)
        return metadata
    }
}
