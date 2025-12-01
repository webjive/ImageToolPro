//
//  AppSettings.swift
//  ImageToolPro
//

import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("replaceOriginalFiles") var replaceOriginalFiles = true
    @AppStorage("useCustomOutput") var useCustomOutput = false
    @AppStorage("customOutputPath") var customOutputPath = ""
    @AppStorage("addFileSuffix") var addFileSuffix = false
    @AppStorage("fileSuffix") var fileSuffix = "-compressed"
}
