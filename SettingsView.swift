//
//  SettingsView.swift
//  ImageToolPro
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        Form {
            Section {
                Toggle("Replace original files", isOn: $settings.replaceOriginalFiles)
                    .help("When enabled, compressed/converted images will replace the original files")
            } header: {
                Text("Output Behavior")
            }
            
            Section {
                Toggle("Use custom output location", isOn: $settings.useCustomOutput)
                    .help("When enabled, processed files will be saved to a custom location")
                
                if settings.useCustomOutput {
                    HStack {
                        TextField("Output Path", text: $settings.customOutputPath)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Choose...") {
                            chooseOutputFolder()
                        }
                    }
                }
            } header: {
                Text("Custom Output Location")
            }
            
            Section {
                Toggle("Add suffix to filename", isOn: $settings.addFileSuffix)
                    .help("When enabled, a suffix will be added to processed filenames")
                
                if settings.addFileSuffix {
                    HStack {
                        Text("Suffix:")
                        TextField("e.g., -compressed", text: $settings.fileSuffix)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                    }
                    
                    Text("Example: image\(settings.fileSuffix).jpg")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Filename Options")
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("Reset to Defaults") {
                        resetToDefaults()
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 500, height: 400)
    }
    
    private func chooseOutputFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.message = "Choose output folder for processed images"
        
        if panel.runModal() == .OK, let url = panel.url {
            settings.customOutputPath = url.path
        }
    }
    
    private func resetToDefaults() {
        settings.replaceOriginalFiles = true
        settings.useCustomOutput = false
        settings.customOutputPath = ""
        settings.addFileSuffix = false
        settings.fileSuffix = "-compressed"
    }
}
