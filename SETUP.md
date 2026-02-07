# Setup Guide

## Prerequisites

Before you begin, make sure you have:
- **macOS** 14.0 or later
- **Xcode** 15.0 or later
- **Git** installed
- **GitHub account** (for hosting your repo)

## Initial Setup

### 1. Create Xcode Project

Since you already have the Swift files, you need to create an Xcode project:

1. **Open Xcode**
2. **File → New → Project**
3. Choose **iOS → App**
4. Fill in details:
   - Product Name: `MyApp`
   - Organization Identifier: `com.yourcompany` (use your domain)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None (or Core Data if needed)
5. Save in your project folder

### 2. Add Your Files to Xcode

1. Delete the default `ContentView.swift` and `MyAppApp.swift` that Xcode created
2. **Drag and drop** your existing Swift files into the project navigator
3. Make sure **"Copy items if needed"** is checked
4. Ensure the files are added to your app target

### 3. Initialize Git Repository

Open Terminal in your project folder:

```bash
# Navigate to your project
cd /path/to/your/project

# Initialize Git
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit: iOS app setup"
```

### 4. Create GitHub Repository

**Option A: Using GitHub Website**
1. Go to https://github.com/new
2. Name your repository (e.g., `MyApp`)
3. Choose Public or Private
4. **Don't** initialize with README (you already have one)
5. Click "Create repository"

**Option B: Using GitHub CLI** (if installed)
```bash
gh repo create MyApp --public --source=. --remote=origin --push
```

### 5. Push to GitHub

```bash
# Add your GitHub repo as remote
git remote add origin https://github.com/YOUR_USERNAME/MyApp.git

# Rename branch to main (if needed)
git branch -M main

# Push your code
git push -u origin main
```

## Installing Dependencies (Optional)

### Using Swift Package Manager

1. In Xcode: **File → Add Package Dependencies**
2. Enter package URL (see DEPENDENCIES.md for common packages)
3. Choose version
4. Click **Add Package**

### Example: Adding Alamofire

```
1. File → Add Package Dependencies
2. Enter: https://github.com/Alamofire/Alamofire
3. Choose: "Up to Next Major Version" from "5.8.0"
4. Click Add Package
```
### Recommended Packages (Add when ready)

1. **Supabase Swift**
   ```
   https://github.com/supabase-community/supabase-swift
   ```

2. **Plaid Link iOS**
   ```
   https://github.com/plaid/plaid-link-ios
   ```

3. **KeychainAccess** (optional, we have our own)
   ```
   https://github.com/kishikawakatsumi/KeychainAccess
   ```

## Running Your App

1. Open `MyApp.xcodeproj` in Xcode
2. Select a simulator (iPhone 15 Pro recommended)
3. Press `Cmd+R` or click the ▶️ Play button
4. Wait for build to complete
5. Your app will launch in the simulator

## Testing

Run tests with:
- Xcode: Press `Cmd+U`
- Terminal: `swift test` (if using SPM)

## Troubleshooting

### Build Errors
- Clean build folder: `Cmd+Shift+K`
- Reset package caches: **File → Packages → Reset Package Caches**

### Git Issues
- Check remote: `git remote -v`
- Verify credentials: `git config --list`

### Simulator Issues
- Reset simulator: **Device → Erase All Content and Settings**
- Restart Xcode

## Next Steps

You've completed setup! Now you can:
- Start building features
- Add more views and models
- Integrate APIs
- Set up CI/CD (see below)

## Optional: CI/CD Setup

### GitHub Actions (Recommended)

Create `.github/workflows/ios.yml`:

```yaml
name: iOS Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode
      run: sudo xcode-select -s /Applications/Xcode_15.0.app
    
    - name: Build
      run: xcodebuild -scheme MyApp -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
    
    - name: Test
      run: xcodebuild -scheme MyApp -destination 'platform=iOS Simulator,name=iPhone 15 Pro' test
```

## Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Swift.org](https://swift.org)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Hacking with Swift](https://www.hackingwithswift.com)

## Support

If you encounter issues:
1. Check ARCHITECTURE.md for project structure
2. Review CONTRIBUTING.md for guidelines
3. Open an issue on GitHub
