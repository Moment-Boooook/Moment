//
//  DocumentPickerView.swift
//  Moment
//
//  Created by phang on 5/31/24.
//

import SwiftUI

import ComposableArchitecture

// MARK: - 기기의 '파일' 에 접근하여 데이터 가져오기
struct DocumentPickerView: UIViewControllerRepresentable {
    @Bindable var store: StoreOf<SettingViewFeature>
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(
        context: Context
    ) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {
        let documentPicker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.item],
            asCopy: true)
        documentPicker.delegate = context.coordinator
        
        if store.isDocumentPickerViewPresented,
           uiViewController.presentedViewController == nil {
            uiViewController.present(documentPicker, animated: true)
        }
    }
    
    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(
            _ controller: UIDocumentPickerViewController,
            didPickDocumentsAt urls: [URL]
        ) {
            guard let selectedFileURL = urls.first else { return }
            parent.store.send(.setSelectedFileURL(selectedFileURL))
            parent.store.send(.closeDocumentPickerView)
        }
        
        func documentPickerWasCancelled(
            _ controller: UIDocumentPickerViewController
        ) {
            parent.store.send(.setSelectedFileURL(nil))
            parent.store.send(.closeDocumentPickerView)
        }
    }
}
