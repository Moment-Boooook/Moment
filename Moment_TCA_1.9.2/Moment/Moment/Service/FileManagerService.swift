//
//  FileManagerService.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import Foundation

import ComposableArchitecture

// MARK: - FileManager Service
struct FileManagerService {
    // FileManager - 싱글톤
    private static let fileManager = FileManager.default
    // documents
    private static let documentsURL = fileManager.urls(
        for: .documentDirectory,
        in: .userDomainMask)[0]
    // 파일 저장할 directory
    private static let directoryURL = documentsURL.appendingPathComponent(AppLocalized.directotyName)
    // 파일 이름 설정
    // TODO: - 백업 날짜 포함된 파일 이름 사용
    private static let fileURL = directoryURL.appendingPathComponent(AppLocalized.fileName)
    
    var fetchData: () -> Void
    var backUpData: () -> Void
}

extension FileManagerService: DependencyKey {
    static let liveValue = Self(
        fetchData: { 
            //
        },
        backUpData: {
            //
        }
    )
}

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // FileManager Service
    var fileManagerService: FileManagerService {
        get { self[FileManagerService.self] }
        set { self[FileManagerService.self] = newValue }
    }
}
