//
//  ContentView.swift
//  ImageToolPro
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        TabView {
            CompressView()
                .tabItem {
                    Label("Compress", systemImage: "arrow.down.circle")
                }
            
            ConvertView()
                .tabItem {
                    Label("Convert", systemImage: "arrow.triangle.2.circlepath")
                }
        }
        .padding()
    }
}
