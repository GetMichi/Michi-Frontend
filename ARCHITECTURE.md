# Architecture

## Overview
This app follows the MVVM (Model-View-ViewModel) architecture pattern with SwiftUI.

## Project Structure

```
MyApp/
├── App/
│   └── MyApp.swift              # App entry point
│
├── Models/
│   └── Post.swift               # Data models
│
├── Views/
│   ├── ContentView.swift        # Main views
│   └── Components/              # Reusable view components
│
├── ViewModels/
│   └── [ViewModels go here]     # Business logic
│
├── Services/
│   └── NetworkManager.swift     # API and services
│
├── Utilities/
│   ├── Config.swift             # App configuration
│   └── Extensions.swift         # Swift extensions
│
└── Resources/
    └── Assets.xcassets          # Images, colors, etc.
```

## Design Patterns

### MVVM (Model-View-ViewModel)
- **Model**: Data structures (Post.swift)
- **View**: SwiftUI views (ContentView.swift)
- **ViewModel**: Business logic and state management

### Async/Await
- All network calls use Swift Concurrency
- NetworkManager is an Actor for thread safety

### SwiftUI Best Practices
- Use @State for local view state
- Use @StateObject/@ObservedObject for ViewModels
- Use @Environment for dependency injection

## Data Flow

1. **View** displays UI and handles user interaction
2. **ViewModel** processes business logic and manages state
3. **Model** represents data
4. **NetworkManager** handles API communication

## Key Principles

- **Single Responsibility**: Each file has one clear purpose
- **Separation of Concerns**: Views don't contain business logic
- **Testability**: ViewModels can be tested independently
- **Reusability**: Common components are extracted

## Future Considerations

- Add Repository pattern for data layer
- Implement Coordinator pattern for navigation
- Add dependency injection container
