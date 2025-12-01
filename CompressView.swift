//
//  CompressView.swift
//  ImageToolPro
//

import SwiftUI
import UniformTypeIdentifiers

struct CompressView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var files: [ImageFileInfo] = []
    @State private var isDragging = false
    @State private var compressionQuality: Double = 80
    @State private var isProcessing = false
    
    private let supportedTypes: [UTType] = [
        .heic, .png, .jpeg, .webP, .tiff, .bmp
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with quality slider
            VStack(alignment: .leading, spacing: 10) {
                Text("Compression Quality: \(Int(compressionQuality))%")
                    .font(.headline)
                
                HStack {
                    Slider(value: $compressionQuality, in: 10...90, step: 10)
                        .frame(maxWidth: 400)
                    
                    Text("\(Int(compressionQuality))%")
                        .frame(width: 50, alignment: .trailing)
                        .monospacedDigit()
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            // Drop zone
            if files.isEmpty {
                DropZoneView(isDragging: $isDragging, supportedTypes: supportedTypes) { urls in
                    addFiles(urls)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // File list
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("File")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Original Size")
                            .frame(width: 120, alignment: .trailing)
                        Text("Compressed Size")
                            .frame(width: 120, alignment: .trailing)
                        Text("Saved")
                            .frame(width: 80, alignment: .trailing)
                        Text("Status")
                            .frame(width: 100, alignment: .center)
                    }
                    .font(.headline)
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    
                    Divider()
                    
                    // File rows
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(files) { file in
                                FileRowView(file: file)
                                Divider()
                            }
                        }
                    }
                    .background(
                        DropZoneView(isDragging: $isDragging, supportedTypes: supportedTypes, showText: false) { urls in
                            addFiles(urls)
                        }
                    )
                }
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
            }
            
            // Action buttons
            HStack {
                Button("Clear All") {
                    files.removeAll()
                }
                .disabled(files.isEmpty || isProcessing)
                
                Spacer()
                
                Button("Compress Images") {
                    Task {
                        await compressImages()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(files.isEmpty || isProcessing)
            }
        }
        .padding()
    }
    
    private func addFiles(_ urls: [URL]) {
        for url in urls {
            // Check if file is already in the list
            if files.contains(where: { $0.url == url }) {
                continue
            }
            
            // Get file size
            if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
               let fileSize = attributes[.size] as? Int64 {
                let fileInfo = ImageFileInfo(url: url, originalSize: fileSize)
                files.append(fileInfo)
            }
        }
    }
    
    private func compressImages() async {
        isProcessing = true
        
        for index in files.indices {
            files[index].status = .processing
            
            do {
                let processor = ImageProcessor()
                let quality = compressionQuality / 100.0
                let outputURL = try await processor.compressImage(
                    url: files[index].url,
                    quality: quality,
                    settings: settings
                )
                
                // Get processed file size
                if let attributes = try? FileManager.default.attributesOfItem(atPath: outputURL.path),
                   let fileSize = attributes[.size] as? Int64 {
                    files[index].processedSize = fileSize
                }
                
                files[index].status = .completed
            } catch {
                files[index].status = .failed
                files[index].error = error.localizedDescription
            }
        }
        
        isProcessing = false
    }
}

struct FileRowView: View {
    let file: ImageFileInfo
    
    var body: some View {
        HStack {
            Text(file.url.lastPathComponent)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(file.originalSizeString)
                .frame(width: 120, alignment: .trailing)
                .monospacedDigit()
            
            Text(file.processedSizeString)
                .frame(width: 120, alignment: .trailing)
                .monospacedDigit()
            
            if let ratio = file.compressionRatio {
                Text(ratio)
                    .frame(width: 80, alignment: .trailing)
                    .monospacedDigit()
                    .foregroundColor(.green)
            } else {
                Text("-")
                    .frame(width: 80, alignment: .trailing)
            }
            
            StatusBadge(status: file.status)
                .frame(width: 100, alignment: .center)
        }
        .padding()
    }
}

struct StatusBadge: View {
    let status: ProcessingStatus
    
    var body: some View {
        Group {
            switch status {
            case .pending:
                Text("Pending")
                    .foregroundColor(.secondary)
            case .processing:
                HStack(spacing: 4) {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 12, height: 12)
                    Text("Processing")
                }
                .foregroundColor(.blue)
            case .completed:
                Label("Done", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
            case .failed:
                Label("Failed", systemImage: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .font(.caption)
    }
}
