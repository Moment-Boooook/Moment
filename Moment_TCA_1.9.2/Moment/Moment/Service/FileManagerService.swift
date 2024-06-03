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
    var restoreData: (URL) throws -> Void
}

extension FileManagerService: DependencyKey {
    static let liveValue = Self(
        // 백업을 위한, 압축
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
        // 복원 + 복원을 위한 압축 해제
        restoreData: { url in
            // 기존 SwiftData 파일들
            guard let swiftDataFiles = getSwiftDataFiles() else {
                throw BackupAndRestoreError.backup
            }
            // 이미 존재하는지 확인 / 삭제
            do {
                for swiftDataFileURL in swiftDataFiles {
                    if fileManager.fileExists(atPath: swiftDataFileURL.path) {
                        try fileManager.removeItem(at: swiftDataFileURL)
                    }
                }
            } catch {
                throw BackupAndRestoreError.fileManager
            }
            // 파일 압축 해제
            guard let documentsDir = fileManager.urls(for: .applicationSupportDirectory,
                                                      in: .userDomainMask).first
            else {                 
                throw BackupAndRestoreError.fileManager
            }
            do {
                try decompressFiles(from: url, to: documentsDir)
            } catch {
                throw CompressionError.decompress
            }
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
        to destinationURL: URL
    ) throws {
        do {
            try fileManager.createDirectory(at: destinationURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            try fileManager.unzipItem(at: sourceURL, to: destinationURL)
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
