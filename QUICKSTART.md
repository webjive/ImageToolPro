# Quick Start Guide - ImageToolPro

This guide will walk you through building your ImageToolPro app from start to finish.

## Prerequisites

✓ macOS Tahoe 26.1 (you have this)  
✓ Xcode 16+ (free from Mac App Store)  
✓ Apple ID (free - for code signing)

## Step-by-Step Build Instructions

### Step 1: Open Xcode and Create New Project

1. Launch **Xcode** from Applications or Spotlight
2. You'll see the Welcome window
3. Click **"Create New Project"** (or File → New → Project)

### Step 2: Choose Template

1. At the top, select the **macOS** tab
2. Select **App** template
3. Click **Next**

### Step 3: Configure Project

Fill in these fields:
- **Product Name**: `ImageToolPro`
- **Team**: Select your Apple ID from the dropdown
  - If you don't see your Apple ID, click "Add Account..." and sign in
- **Organization Identifier**: `com.yourname` (use your actual name, lowercase, no spaces)
- **Bundle Identifier**: Will auto-fill as `com.yourname.ImageToolPro`
- **Interface**: **SwiftUI** (make sure this is selected)
- **Language**: **Swift**
- **Uncheck** "Use Core Data"
- **Uncheck** "Include Tests"

Click **Next**

### Step 4: Choose Save Location

1. Navigate to your Desktop or Documents folder
2. **Important**: Note where you save this
3. Click **Create**

Xcode will create and open your new project.

### Step 5: Add Source Files

Now you need to add the ImageToolPro source files to your project:

1. In Xcode, look at the left sidebar (Project Navigator)
2. You'll see:
   ```
   ImageToolPro
   ├── ImageToolProApp.swift
   ├── ContentView.swift
   └── Assets.xcassets
   ```

3. **Delete** the default `ContentView.swift`:
   - Right-click it → Delete → Move to Trash

4. **Add the new source files**:
   - Open Finder and navigate to the folder where you downloaded ImageToolPro
   - Select ALL .swift files:
     - ImageToolProApp.swift (replace the default one)
     - ContentView.swift
     - CompressView.swift
     - ConvertView.swift
     - SettingsView.swift
     - DropZoneView.swift
     - ImageProcessor.swift
     - AppSettings.swift
     - ImageFileInfo.swift
   
   - **Drag and drop** these files into the Xcode project navigator
   - In the dialog that appears:
     - ✓ Check "Copy items if needed"
     - ✓ Check "ImageToolPro" under "Add to targets"
     - Click **Finish**

### Step 6: Configure Build Settings

1. Click on **ImageToolPro** (the blue project icon) at the top of the navigator
2. Make sure **ImageToolPro** is selected under TARGETS (not PROJECT)
3. Click the **General** tab

Configure these settings:
- **Deployment Info**
  - Minimum System Version: `26.0`
- **Identity**
  - Bundle Identifier: Should be `com.yourname.ImageToolPro`

4. Click the **Signing & Capabilities** tab
   - ✓ Check **"Automatically manage signing"**
   - Team: Should show your Apple ID
   - If you see any red errors here, click "Try Again" or select your Team again

### Step 7: Build the App

1. At the top of Xcode, make sure the scheme shows:
   ```
   ImageToolPro > My Mac
   ```

2. Click **Product** menu → **Build** (or press ⌘B)

3. Wait for the build to complete (you'll see "Build Succeeded" in the top bar)

### Step 8: Run and Test

1. Click the **Play button** (▶) in the top left, or press ⌘R
2. ImageToolPro will launch!
3. Try it out:
   - Compress tab: Drag some images and compress them
   - Convert tab: Convert images to different formats
   - Settings: Press ⌘, to open preferences

### Step 9: Create Standalone App

To get an .app file you can move anywhere:

1. In Xcode: **Product** → **Archive**
2. Wait for the archive to complete
3. The Organizer window will appear
4. Select your archive and click **"Distribute App"**
5. Choose **"Copy App"**
6. Click **Next** → **Export**
7. Choose where to save (e.g., Desktop)
8. Click **Export**

You now have a standalone **ImageToolPro.app** you can:
- Move to Applications folder
- Copy to other Macs
- Share with others

## Troubleshooting

### "ImageToolPro" can't be opened

First time running a self-signed app:
1. Right-click the app
2. Select **"Open"**
3. Click **"Open"** in the dialog

This tells macOS you trust the app.

### Build Errors

**"No accounts with App Store Connect access"**
- Go to Xcode → Settings → Accounts
- Click + and add your Apple ID

**"Failed to register bundle identifier"**
- Change the Bundle Identifier in project settings
- Try: `com.firstname-lastname.ImageToolPro`

**"Command CompileSwift failed"**
- Make sure all .swift files are added to the target
- Check that no files are missing
- Clean Build Folder: Product → Clean Build Folder

### Red X Errors in Code

- Make sure you added ALL the .swift files
- All files should be in the same group/folder in the project
- Try: File → Close Workspace, then reopen

## Next Steps

- Read the full README.md for advanced features
- Customize the app icon (if you want)
- Add app to Dock for easy access

## That's It!

You now have a fully functional image compression and conversion tool built specifically for your Mac! 🎉

Enjoy processing those images for your web design projects!
