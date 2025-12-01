//
//  DropZoneView.swift
//  ImageToolPro
//

import SwiftUI
import UniformTypeIdentifiers

struct DropZoneView: View {
    @Binding var isDragging: Bool
    let supportedTypes: [UTType]
    var showText: Bool = true
    let onDrop: ([URL]) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isDragging ? Color.accentColor : Color.gray.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [10, 5])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isDragging ? Color.accentColor.opacity(0.1) : Color.clear)
                )
            
            if showText {
                VStack(spacing: 16) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("Drop images here")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("Supported formats: HEIC, PNG, JPG, WebP, TIFF, BMP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onDrop(of: supportedTypes, isTargeted: $isDragging) { providers in
            handleDrop(providers: providers)
            return true
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        var urls: [URL] = []
        let group = DispatchGroup()
        
        for provider in providers {
            group.enter()
            _ = provider.loadObject(ofClass: URL.self) { url, error in
                if let url = url {
                    urls.append(url)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            onDrop(urls)
        }
    }
}
