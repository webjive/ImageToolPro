# ImageToolPro

A native macOS application for image compression and format conversion, built specifically for macOS Tahoe 26.0+.

## Features

### Compress Tab
- **Supported Formats**: HEIC, PNG, JPG, WebP, TIFF, BMP
- **Quality Control**: Adjustable compression from 10% to 90% (default 80%)
- **Batch Processing**: Drag and drop multiple files
- **Before/After Comparison**: See original and compressed file sizes
- **Smart Compression**: Lossless compression optimized for each format

### Convert Tab
- **Input Formats**: HEIC, PNG, JPG, WebP, SVG, TIFF, BMP
- **Output Formats**: JPG, PNG, WebP
- **Batch Conversion**: Convert multiple files at once
- **Original Dimensions**: Maintains image size during conversion

### Settings
- **Replace Original Files**: Option to replace or keep originals
- **Custom Output Location**: Choose where to save processed files
- **Filename Suffix**: Optionally add custom suffix (e.g., `-compressed`)

## System Requirements

- macOS Tahoe 26.0 or later
- Apple Developer account for code signing (free account works)

## Building the App

### Prerequisites

1. Install Xcode 16+ from the Mac App Store
2. Make sure you have Xcode Command Line Tools installed:
   ```bash
   xcode-select --install
   ```

### Build Steps

1. **Create Xcode Project**:
   ```bash
   cd /path/to/ImageToolPro
   
   # Create a new Xcode project directory structure
   mkdir -p ImageToolPro.xcodeproj
   ```

2. **Open in Xcode**:
   - Launch Xcode
   - File → New → Project
   - Choose "macOS" → "App"
   - Product Name: `ImageToolPro`
   - Interface: SwiftUI
   - Language: Swift
   - Save to the parent directory of this folder
   
3. **Replace Source Files**:
   - Delete the default ContentView.swift and other starter files
   - Add all the .swift files from this directory to your Xcode project
   - Drag and drop: ImageToolProApp.swift, ContentView.swift, CompressView.swift, ConvertView.swift, SettingsView.swift, DropZoneView.swift, ImageProcessor.swift, AppSettings.swift, ImageFileInfo.swift

4. **Configure Project**:
   - Select your project in the navigator
   - Under "Signing & Capabilities":
     - Check "Automatically manage signing"
     - Select your Team (your Apple ID)
     - Bundle Identifier: `com.yourname.ImageToolPro`
   - Under "General":
     - Deployment Target: macOS 26.0
     - Minimum System Version: 26.0

5. **Build**:
   - Product → Build (⌘B)
   - If successful, Product → Archive
   - In the Organizer window, select "Distribute App"
   - Choose "Copy App" to export the signed .app file

6. **Run**:
   - The built app will be in:
     `~/Library/Developer/Xcode/DerivedData/ImageToolPro-*/Build/Products/Debug/ImageToolPro.app`
   - Or use Product → Run (⌘R) to test it directly

## Alternative: Command Line Build

If you prefer building from the command line:

```bash
# Navigate to your Xcode project directory
cd /path/to/ImageToolPro

# Build for Release
xcodebuild -scheme ImageToolPro -configuration Release -derivedDataPath ./build

# The app will be in:
# ./build/Build/Products/Release/ImageToolPro.app
```

## Code Signing

For distribution outside the Mac App Store:

1. **Developer ID Certificate** (requires paid Apple Developer account):
   ```bash
   codesign --force --deep --sign "Developer ID Application: Your Name" ImageToolPro.app
   ```

2. **Notarization** (for Gatekeeper compatibility):
   ```bash
   # Create a zip
   ditto -c -k --keepParent ImageToolPro.app ImageToolPro.zip
   
   # Submit for notarization
   xcrun notarytool submit ImageToolPro.zip --apple-id your@email.com --team-id TEAM_ID --wait
   
   # Staple the ticket
   xcrun stapler staple ImageToolPro.app
   ```

## Usage

1. Launch ImageToolPro
2. **To Compress**:
   - Select the "Compress" tab
   - Adjust quality slider (default 80%)
   - Drag and drop images
   - Click "Compress Images"
   
3. **To Convert**:
   - Select the "Convert" tab
   - Choose output format (JPG, PNG, or WebP)
   - Drag and drop images
   - Click "Convert Images"

4. **Settings** (⌘,):
   - Configure output behavior
   - Set custom output location
   - Add filename suffix

## Troubleshooting

### "ImageToolPro" is damaged and can't be opened
This happens if the app isn't signed. Right-click the app and select "Open", then click "Open" in the dialog.

### Images aren't processing
- Check that the images are in supported formats
- Ensure you have write permissions to the output directory
- Check the status column for specific error messages

### WebP support
macOS doesn't have native WebP encoding. The app currently converts to PNG as a fallback for WebP output.

## License

Built for personal use. Modify and distribute as needed.

## Credits

Built with SwiftUI for macOS Tahoe 26.0+
Optimized for web designers and developers who need fast, reliable image compression and conversion.

## Author
- [Eric Caldwell](https://www.web-jive.com)
