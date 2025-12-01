//
//  ImageFileInfo.swift
//  ImageToolPro
//

import Foundation
import AppKit

struct ImageFileInfo: Identifiable {
    let id = UUID()
    let url: URL
    var originalSize: Int64
    var processedSize: Int64?
    var status: ProcessingStatus = .pending
    var error: String?
    
    var originalSizeString: String {
        ByteCountFormatter.string(fromByteCount: originalSize, countStyle: .file)
    }
    
    var processedSizeString: String {
        guard let size = processedSize else { return "-" }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
    
    var compressionRatio: String? {
        guard let processed = processedSize, originalSize > 0 else { return nil }
        let ratio = (1.0 - Double(processed) / Double(originalSize)) * 100
        return String(format: "%.1f%%", ratio)
    }
}

enum ProcessingStatus {
    case pending
    case processing
    case completed
    case failed
}
