#!/bin/bash

# ImageToolPro Build Script
# This script helps set up and build the ImageToolPro app

set -e

echo "======================================"
echo "ImageToolPro Build Script"
echo "======================================"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or xcodebuild is not in PATH"
    echo "Please install Xcode from the Mac App Store"
    exit 1
fi

echo "✓ Xcode found"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "Working directory: $SCRIPT_DIR"
echo ""

# Create a temporary directory for the Xcode project
PROJECT_DIR="$SCRIPT_DIR/Build"
mkdir -p "$PROJECT_DIR"

echo "======================================"
echo "MANUAL SETUP REQUIRED"
echo "======================================"
echo ""
echo "Unfortunately, creating an Xcode project programmatically"
echo "requires additional steps. Please follow these instructions:"
echo ""
echo "1. Open Xcode"
echo "2. File → New → Project"
echo "3. Choose 'macOS' → 'App'"
echo "4. Fill in:"
echo "   - Product Name: ImageToolPro"
echo "   - Team: (select your Apple ID)"
echo "   - Organization Identifier: com.yourname"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "5. Save to: $PROJECT_DIR"
echo ""
echo "6. Once created, add these files to your project:"
echo "   - ImageToolProApp.swift"
echo "   - ContentView.swift"
echo "   - CompressView.swift"
echo "   - ConvertView.swift"
echo "   - SettingsView.swift"
echo "   - DropZoneView.swift"
echo "   - ImageProcessor.swift"
echo "   - AppSettings.swift"
echo "   - ImageFileInfo.swift"
echo ""
echo "7. In Project Settings:"
echo "   - Set Deployment Target to macOS 26.0"
echo "   - Enable 'Automatically manage signing'"
echo ""
echo "8. Build with Product → Build (⌘B)"
echo ""
echo "======================================"
echo ""

# Offer to open the folder in Finder
read -p "Would you like to open this folder in Finder? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "$SCRIPT_DIR"
fi

echo ""
echo "For detailed instructions, see README.md"
