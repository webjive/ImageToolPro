# ImageToolPro - Project Overview

## What Is This?

ImageToolPro is a native macOS application built specifically for macOS Tahoe 26.0+ that provides:

1. **Image Compression** - Reduce file sizes while maintaining quality
2. **Format Conversion** - Convert between different image formats

This app was designed to replace the Image Optimizer app that doesn't work correctly on macOS Tahoe.

## Key Features

### Compression
- Adjustable quality slider (10-90%, default 80%)
- Lossless compression for supported formats
- Before/after file size comparison
- Batch processing support
- Formats: HEIC, PNG, JPG, WebP, TIFF, BMP

### Conversion  
- Convert to JPG, PNG, or WebP
- Maintains original dimensions
- Batch conversion
- Input formats: HEIC, PNG, JPG, WebP, SVG, TIFF, BMP

### Settings
- Replace original files or keep both
- Custom output location
- Optional filename suffix (e.g., "-compressed")

## File Structure

```
ImageToolPro/
├── ImageToolProApp.swift      # Main app entry point
├── ContentView.swift           # Tab view container
├── CompressView.swift          # Compression tab UI
├── ConvertView.swift           # Conversion tab UI
├── SettingsView.swift          # Preferences window
├── DropZoneView.swift          # Reusable drag-and-drop component
├── ImageProcessor.swift        # Core compression/conversion logic
├── AppSettings.swift           # User preferences storage
├── ImageFileInfo.swift         # File information model
├── Info.plist                  # App metadata
├── README.md                   # Full documentation
├── QUICKSTART.md               # Step-by-step build guide
└── build.sh                    # Helper build script
```

## Architecture

### SwiftUI Views
- **ImageToolProApp**: Main app structure with WindowGroup and Settings
- **ContentView**: TabView with Compress and Convert tabs
- **CompressView**: Handles compression workflow with quality slider
- **ConvertView**: Handles format conversion with format picker
- **SettingsView**: Configuration options using Form
- **DropZoneView**: Reusable drag-and-drop zone with file validation

### Data Models
- **AppSettings**: ObservableObject storing user preferences via @AppStorage
- **ImageFileInfo**: Tracks individual file processing status and sizes
- **ProcessingStatus**: Enum for file processing states
- **OutputFormat**: Enum for supported output formats

### Core Logic
- **ImageProcessor**: Handles all image manipulation
  - Compression using NSBitmapImageRep with quality settings
  - Format conversion using native macOS image APIs
  - File path management and output location logic
  - Error handling for invalid images and unsupported formats

## Technology Stack

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Image Processing**: AppKit (NSImage, NSBitmapImageRep)
- **Storage**: UserDefaults via @AppStorage
- **Async**: Swift Concurrency (async/await)

## Build Requirements

- Xcode 16 or later
- macOS Tahoe 26.0 SDK
- Apple Developer account (free tier is sufficient)

## How to Build

See **QUICKSTART.md** for detailed step-by-step instructions.

Quick summary:
1. Create new Xcode project (macOS App, SwiftUI)
2. Add all .swift files to the project
3. Set deployment target to macOS 26.0
4. Configure code signing with your Apple ID
5. Build and run

## Design Decisions

### Why SwiftUI?
- Native to macOS Tahoe
- Declarative UI perfect for this use case
- Built-in drag-and-drop support
- Automatic dark mode support
- Less code than AppKit

### Why NSImage Instead of CoreImage?
- Simpler API for basic compression
- Direct access to bitmap representations
- Native support for all required formats
- No need for complex filter chains

### Quality Slider Design
- 10% increments for clear quality levels
- 80% default as optimal balance
- Range 10-90% prevents extreme compression
- Visual percentage display for transparency

### Settings Approach
- @AppStorage for automatic persistence
- Sensible defaults (replace originals enabled)
- Clear options without overwhelming users
- Native macOS Settings window

## Future Enhancements

Potential improvements for v2.0:
- Native WebP encoding (requires libwebp integration)
- SVG to PNG/JPG conversion (requires SVG renderer)
- Drag-and-drop folder support with subfolder processing
- Image preview before/after
- Undo/Redo support
- Custom compression profiles
- Batch resize during conversion
- EXIF data preservation options
- Progress notifications
- Menu bar app mode

## Performance Considerations

- Async processing prevents UI blocking
- Files processed sequentially (could be parallelized)
- Memory efficient - processes one image at a time
- Native APIs = optimal macOS integration

## Known Limitations

1. **WebP Output**: Converts to PNG instead of WebP (macOS lacks native WebP encoder)
2. **SVG Input**: Reads as bitmap, doesn't preserve vector data
3. **Sequential Processing**: Processes files one at a time (not parallel)
4. **No Progress Bar**: Currently shows status only, not percentage
5. **HEIC Compression**: May convert to JPEG for compatibility

## Testing Checklist

Before shipping, test:
- [ ] Compress each format type (PNG, JPG, HEIC, etc.)
- [ ] Convert to each output format
- [ ] Quality slider at different levels
- [ ] Replace original files option
- [ ] Custom output location
- [ ] Filename suffix
- [ ] Batch processing (10+ files)
- [ ] Large files (10MB+)
- [ ] Invalid/corrupted images
- [ ] Drag and drop from Finder
- [ ] Settings persistence after restart

## License

This is custom software built for personal use. Feel free to modify, distribute, or use commercially.

## Support

For questions or issues:
1. Check QUICKSTART.md for build problems
2. Check README.md for usage questions
3. Review code comments in source files

## Credits

Built with ❤️ for web designers who need fast, reliable image processing on macOS Tahoe.

Optimized for the Web-JIVE workflow:
- Compress for faster website loading
- Convert HEIC from iPhone to web-friendly formats
- Batch process client images efficiently
