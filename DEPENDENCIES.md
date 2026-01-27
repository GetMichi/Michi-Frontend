# Swift Package Manager
# Add your dependencies here

dependencies: [
    // Example:
    // .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
]

# Common Swift Packages for iOS Development:

## Networking
- Alamofire: https://github.com/Alamofire/Alamofire

## JSON Parsing
- SwiftyJSON: https://github.com/SwiftyJSON/SwiftyJSON

## UI Components
- SDWebImage: https://github.com/SDWebImage/SDWebImage (For SwiftUI: SDWebImageSwiftUI)
- Lottie: https://github.com/airbnb/lottie-ios

## Firebase
- Firebase iOS SDK: https://github.com/firebase/firebase-ios-sdk

## Database
- Realm: https://github.com/realm/realm-swift
- GRDB: https://github.com/groue/GRDB.swift

## Testing
- Quick/Nimble: https://github.com/Quick/Quick

## Utilities
- SwiftLint: https://github.com/realm/SwiftLint

---

## How to Add Packages in Xcode:

1. Open your project in Xcode
2. Go to File → Add Package Dependencies
3. Enter the package URL
4. Choose version/branch
5. Click "Add Package"

## Or via Package.swift:

If using Swift Package Manager directly, edit Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/package/url.git", from: "1.0.0")
]
```
