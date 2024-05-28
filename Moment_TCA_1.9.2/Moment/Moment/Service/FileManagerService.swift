//
//  FileManagerService.swift
//  Moment
//
//  Created by phang on 5/16/24.
//

import Foundation

import ComposableArchitecture
import ZIPFoundation

// MARK: - FileManager Service
struct FileManagerService {
    // FileManager - 싱글톤
    private static let fileManager = FileManager.default
    
    var compressData: () -> AsyncThrowingStream<URL, Error>
    var restoreData: () -> Void
}

extension FileManagerService: DependencyKey {
    static let liveValue = Self(
        compressData: {
            AsyncThrowingStream<URL, Error> { continuation in
                // 기존 SwiftData 파일들
                guard let swiftDataFiles = getSwiftDataFiles() else {
                    continuation.finish(throwing: BackupAndRestoreError.backup)
                    return
                }
                // 임시 압축 파일 주소
                let temporaryDirectoryURL = fileManager.temporaryDirectory.appendingPathComponent(
                    "\(Date().formattedToString())\(AppLocalized.fileType)")
                // 이미 존재하는지 확인 / 삭제
                do {
                    if fileManager.fileExists(atPath: temporaryDirectoryURL.path) {
                        try fileManager.removeItem(at: temporaryDirectoryURL)
                    }
                } catch {
                    continuation.finish(throwing: BackupAndRestoreError.fileManager)
                }
                // 파일 압축
                do {
                    try compressFiles(temporaryDirectoryURL: temporaryDirectoryURL,
                                      swiftDataFiles: swiftDataFiles)
                } catch {
                    continuation.finish(throwing: CompressionError.compress)
                }
                // 성공 반환
                continuation.yield(temporaryDirectoryURL)
            }
        },
        restoreData: {
            //
        }
    )
}

// MARK: - 백업 / 복원
extension FileManagerService {
    // 기존 SwiftData 주소
    private static func getSwiftDataFiles() -> [URL]? {
        guard let documentsDir = fileManager.urls(for: .applicationSupportDirectory,
                                                  in: .userDomainMask).first 
        else {
            return nil
        }
        let storeURL = documentsDir.appendingPathComponent(AppLocalized.storeFile)
        let shmURL = documentsDir.appendingPathComponent(AppLocalized.shmFile)
        let walURL = documentsDir.appendingPathComponent(AppLocalized.walFile)
        return [storeURL, shmURL, walURL]
    }
    
    // 백업 할 주소
    private static func backupURL() -> URL? {
        guard let documentsDir = fileManager.urls(for: .documentDirectory,
                                                  in: .userDomainMask).first 
        else {
            return nil
        }
        return documentsDir.appendingPathComponent(
            "\(Date().formattedToString())\(AppLocalized.fileType)") // 저장할 백업 파일
    }
}

// MARK: - 압축 / 해제
extension FileManagerService {
    // 파일 압축 (default.store, default.store-shm, default.store-wal)
    // yyyy_mm_dd.moment
    private static func compressFiles(
        temporaryDirectoryURL: URL,
        swiftDataFiles: [URL]
    ) throws {
        let archive = try Archive(url: temporaryDirectoryURL,
                                  accessMode: .create)
        for fileURL in swiftDataFiles {
            try archive.addEntry(with: fileURL.lastPathComponent,
                                 fileURL: fileURL)
        }
    }
    
    // 해제
    private static func decompressFiles(
        from sourceURL: URL,
        to destinationDirectory: URL
    ) throws {
        do {
            let archive = try Archive(url: sourceURL,
                                      accessMode: .read)
            for entry in archive {
                let destinationURL = destinationDirectory.appendingPathComponent(entry.path)
                let _ = try archive.extract(entry, to: destinationURL)
            }
            return
        } catch {
            throw CompressionError.decompress
        }
    }
}

// MARK: - TCA : DependencyValues +
extension DependencyValues {
    // FileManager Service
    var fileManagerService: FileManagerService {
        get { self[FileManagerService.self] }
        set { self[FileManagerService.self] = newValue }
    }
}
