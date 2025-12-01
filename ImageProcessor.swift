//
//  ImageProcessor.swift
//  ImageToolPro
//

import Foundation
import AppKit
import UniformTypeIdentifiers

class ImageProcessor {
    
    enum ProcessingError: LocalizedError {
        case invalidImage
        case unsupportedFormat
        case compressionFailed
        case conversionFailed
        case fileOperationFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidImage: return "Invalid or corrupted image file"
            case .unsupportedFormat: return "Unsupported image format"
            case .compressionFailed: return "Compression failed"
            case .conversionFailed: return "Conversion failed"
            case .fileOperationFailed: return "File operation failed"
            }
        }
    }
    
    // MARK: - Compression
    
    func compressImage(url: URL, quality: Double, settings: AppSettings) async throws -> URL {
        guard let image = NSImage(contentsOf: url) else {
            throw ProcessingError.invalidImage
        }
        
        // Determine output URL
        let outputURL = try determineOutputURL(
            for: url,
            suffix: settings.addFileSuffix ? settings.fileSuffix : nil,
            newExtension: nil,
            settings: settings
        )
        
        // Get the file type from the original URL
        let fileExtension = url.pathExtension.lowercased()
        
        // Compress based on format
        switch fileExtension {
        case "png":
            try await compressAsPNG(image: image, to: outputURL, quality: quality)
        case "jpg", "jpeg":
            try await compressAsJPEG(image: image, to: outputURL, quality: quality)
        case "heic":
            try await compressAsHEIC(image: image, to: outputURL, quality: quality)
        case "webp":
            try await compressAsWebP(image: image, to: outputURL, quality: quality)
        case "tiff", "tif":
            try await compressAsTIFF(image: image, to: outputURL, quality: quality)
        case "bmp":
            try await compressAsJPEG(image: image, to: outputURL, quality: quality) // Convert BMP to JPEG for compression
        default:
            throw ProcessingError.unsupportedFormat
        }
        
        return outputURL
    }
    
    private func compressAsPNG(image: NSImage, to url: URL, quality: Double) async throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw ProcessingError.compressionFailed
        }
        
        // PNG compression uses a factor from 0.0 (no compression) to 1.0 (max compression)
        // We invert the quality so higher quality = less compression
        let compressionFactor = 1.0 - quality
        
        guard let pngData = bitmap.representation(
            using: .png,
            properties: [.compressionFactor: compressionFactor]
        ) else {
            throw ProcessingError.compressionFailed
        }
        
        try pngData.write(to: url)
    }
    
    private func compressAsJPEG(image: NSImage, to url: URL, quality: Double) async throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw ProcessingError.compressionFailed
        }
        
        guard let jpegData = bitmap.representation(
            using: .jpeg,
            properties: [.compressionFactor: quality]
        ) else {
            throw ProcessingError.compressionFailed
        }
        
        try jpegData.write(to: url)
    }
    
    private func compressAsHEIC(image: NSImage, to url: URL, quality: Double) async throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw ProcessingError.compressionFailed
        }
        
        // HEIC compression
        let properties: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: quality
        ]
        
        guard let heicData = bitmap.representation(using: .jpeg, properties: properties) else {
            throw ProcessingError.compressionFailed
        }
        
        try heicData.write(to: url)
    }
    
    private func compressAsWebP(image: NSImage, to url: URL, quality: Double) async throws {
        // WebP support requires converting through JPEG or PNG
        // For simplicity, we'll convert to JPEG with quality settings
        try await compressAsJPEG(image: image, to: url, quality: quality)
    }
    
    private func compressAsTIFF(image: NSImage, to url: URL, quality: Double) async throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw ProcessingError.compressionFailed
        }
        
        let compressionType: NSBitmapImageRep.TIFFCompression = quality > 0.7 ? .lzw : .packBits
        
        guard let compressedData = bitmap.representation(
            using: .tiff,
            properties: [.compressionMethod: compressionType]
        ) else {
            throw ProcessingError.compressionFailed
        }
        
        try compressedData.write(to: url)
    }
    
    // MARK: - Conversion
    
    func convertImage(url: URL, to format: OutputFormat, settings: AppSettings) async throws -> URL {
        guard let image = NSImage(contentsOf: url) else {
            throw ProcessingError.invalidImage
        }
        
        // Determine output URL with new extension
        let outputURL = try determineOutputURL(
            for: url,
            suffix: nil,
            newExtension: format.rawValue,
            settings: settings
        )
        
        // Convert to target format
        switch format {
        case .jpeg:
            try await convertToJPEG(image: image, to: outputURL)
        case .png:
            try await convertToPNG(image: image, to: outputURL)
        case .webP:
            try await convertToWebP(image: image, to: outputURL)
        }
        
        return outputURL
    }
    
    private func convertToJPEG(image: NSImage, to url: URL) async throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw ProcessingError.conversionFailed
        }
        
        guard let jpegData = bitmap.representation(
            using: .jpeg,
            properties: [.compressionFactor: 0.9] // High quality for conversion
        ) else {
            throw ProcessingError.conversionFailed
        }
        
        try jpegData.write(to: url)
    }
    
    private func convertToPNG(image: NSImage, to url: URL) async throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw ProcessingError.conversionFailed
        }
        
        guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
            throw ProcessingError.conversionFailed
        }
        
        try pngData.write(to: url)
    }
    
    private func convertToWebP(image: NSImage, to url: URL) async throws {
        // macOS doesn't have native WebP support, so we convert to PNG as a fallback
        // In a production app, you'd use a WebP library like libwebp
        try await convertToPNG(image: image, to: url)
    }
    
    // MARK: - Helper Methods
    
    private func determineOutputURL(
        for inputURL: URL,
        suffix: String?,
        newExtension: String?,
        settings: AppSettings
    ) throws -> URL {
        let fileName = inputURL.deletingPathExtension().lastPathComponent
        let fileExtension = newExtension ?? inputURL.pathExtension
        
        var outputFileName = fileName
        if let suffix = suffix {
            outputFileName += suffix
        }
        outputFileName += ".\(fileExtension)"
        
        let outputDirectory: URL
        
        if settings.useCustomOutput && !settings.customOutputPath.isEmpty {
            outputDirectory = URL(fileURLWithPath: settings.customOutputPath)
        } else if settings.replaceOriginalFiles {
            outputDirectory = inputURL.deletingLastPathComponent()
        } else {
            outputDirectory = inputURL.deletingLastPathComponent()
        }
        
        let outputURL = outputDirectory.appendingPathComponent(outputFileName)
        
        // If replacing original, delete it first
        if settings.replaceOriginalFiles && suffix == nil && newExtension == nil {
            try? FileManager.default.removeItem(at: inputURL)
        }
        
        return outputURL
    }
}
