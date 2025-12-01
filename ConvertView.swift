//
//  ConvertView.swift
//  ImageToolPro
//

import SwiftUI
import UniformTypeIdentifiers

struct ConvertView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var files: [ImageFileInfo] = []
    @State private var isDragging = false
    @State private var outputFormat: OutputFormat = .jpeg
    @State private var isProcessing = false
    
    private let supportedTypes: [UTType] = [
        .heic, .png, .jpeg, .webP, .tiff, .bmp, .svg
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with format selector
            VStack(alignment: .leading, spacing: 10) {
                Text("Output Format")
                    .font(.headline)
                
                Picker("Convert to:", selection: $outputFormat) {
                    ForEach(OutputFormat.allCases, id: \.self) { format in
                        Text(format.rawValue.uppercased())
                            .tag(format)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 400)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            // Drop zone or file list
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
                        Text("Current Format")
                            .frame(width: 140, alignment: .center)
                        Text("Output Format")
                            .frame(width: 140, alignment: .center)
                        Text("Status")
                            .frame(width: 120, alignment: .center)
                    }
                    .font(.headline)
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    
                    Divider()
                    
                    // File rows
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(files) { file in
                                ConversionFileRowView(file: file, outputFormat: outputFormat)
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
                
                Button("Convert Images") {
                    Task {
                        await convertImages()
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
    
    private func convertImages() async {
        isProcessing = true
        
        for index in files.indices {
            files[index].status = .processing
            
            do {
                let processor = ImageProcessor()
                let outputURL = try await processor.convertImage(
                    url: files[index].url,
                    to: outputFormat,
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

struct ConversionFileRowView: View {
    let file: ImageFileInfo
    let outputFormat: OutputFormat
    
    var currentFormat: String {
        file.url.pathExtension.uppercased()
    }
    
    var body: some View {
        HStack {
            Text(file.url.lastPathComponent)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(currentFormat)
                .frame(width: 140, alignment: .center)
                .padding(4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
            
            Image(systemName: "arrow.right")
                .foregroundColor(.secondary)
            
            Text(outputFormat.rawValue.uppercased())
                .frame(width: 140, alignment: .center)
                .padding(4)
                .background(Color.green.opacity(0.1))
                .cornerRadius(4)
            
            StatusBadge(status: file.status)
                .frame(width: 120, alignment: .center)
        }
        .padding()
    }
}

enum OutputFormat: String, CaseIterable {
    case jpeg = "jpg"
    case png = "png"
    case webP = "webp"
}
