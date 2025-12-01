//
//  ImageToolProApp.swift
//  ImageToolPro
//
//  A native macOS app for image compression and format conversion
//  Built for macOS Tahoe 26.0+
//

import SwiftUI

@main
struct ImageToolProApp: App {
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .frame(minWidth: 800, minHeight: 600)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        
        Settings {
            SettingsView()
                .environmentObject(settings)
        }
    }
}
