//
//  CameraSnap.swift
//  Moment
//
//  Created by phang on 12/12/23.
//

import SwiftUI

import ComposableArchitecture

// MARK: - UIKit 의 UIImagePickerController 로, 카메라 사용
struct CameraSnap: UIViewControllerRepresentable {
    @Bindable var store: StoreOf<AddRecordViewFeature>

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraSnap
        
        init(parent: CameraSnap) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.store.selectedImages.append(uiImage)
            }
            parent.store.isCameraSnapSheet = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.store.isCameraSnapSheet = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraSnap>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.cameraFlashMode = .auto
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraSnap>) {
        //
    }
}
