//
//  URL +.swift
//  Moment
//
//  Created by phang on 5/28/24.
//

import Foundation

extension URL {
    // 파일 크기를 형식으로 반환
    func formattedFileSize() -> String {
        do {
            let size = try self.fileSize()
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB, .useGB]
            formatter.countStyle = .file
            return formatter.string(fromByteCount: Int64(size))
        } catch {
            print(error.localizedDescription)
            return .empty
        }
    }
    
    // 파일의 크기를 바이트 단위로 반환
    private func fileSize() throws -> UInt64 {
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: self.path)
        if let fileSize = fileAttributes[.size] as? UInt64 {
            return fileSize
        } else {
            throw NSError(domain: "FileSizeError",
                          code: 1,
                          userInfo: [
                            NSLocalizedDescriptionKey: "File size attribute not found"
                          ]
            )
        }
    }
}
