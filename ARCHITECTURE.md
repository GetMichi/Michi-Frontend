# Architecture

## Overview
This app follows the MVVM (Model-View-ViewModel) architecture pattern with SwiftUI.

## Project Structure

```
Michi-iOS/
├── MichiApp.swift                 # App entry point
├── ContentView.swift              # Main tab navigation
│
├── Models/
│   └── Models.swift               # All data models
│
├── Views/
│   ├── DashboardView.swift        # Main dashboard
│   ├── ChatView.swift             # AI coach chat interface
│   └── PlaceholderViews.swift     # Auth, onboarding, etc.
│
├── ViewModels/
│   ├── DashboardViewModel.swift   # Dashboard business logic
│   └── ChatViewModel.swift        # Chat with streaming support
│
├── Services/
│   ├── NetworkManager.swift       # API client with streaming
│   └── KeychainManager.swift      # Secure token storage
│
└── Utilities/
    ├── Config.swift               # App configuration
    └── Extensions.swift           # Swift extensions
```

## Design Patterns

### MVVM (Model-View-ViewModel)
- **Model**: Data structures (Post.swift)
- **View**: SwiftUI views (ContentView.swift)
- **ViewModel**: Business logic and state management
- **Why MVVM?**:
1. **Separation of Concerns**: Clear boundaries between UI, business logic, and data
2. **Testability**: ViewModels can be tested without UI
3. **SwiftUI Alignment**: Natural fit with SwiftUI's declarative paradigm
4. **Scalability**: Easy to add features without bloating views
5. **Team Collaboration**: Clear ownership of different layers

### Layer Responsibilities

```
┌─────────────────────────────────────────┐
│              View (SwiftUI)             │
│  - UI rendering                         │
│  - User interaction                     │
│  - Observes ViewModel state             │
│  - NO business logic                    │
└─────────────────────────────────────────┘
                    │
                    │ @StateObject / @ObservedObject
                    ▼
┌─────────────────────────────────────────┐
│           ViewModel (@MainActor)         │
│  - Screen state management              │
│  - Business logic                       │
│  - API calls via Services               │
│  - Data formatting                      │
│  - Error handling                       │
└─────────────────────────────────────────┘
                    │
                    │ async/await
                    ▼
┌─────────────────────────────────────────┐
│              Services (Actor)            │
│  - Network requests                     │
│  - Data persistence                     │
│  - External integrations                │
│  - Thread-safe operations               │
└─────────────────────────────────────────┘
                    │
                    │
                    ▼
┌─────────────────────────────────────────┐
│           Model (Struct/Enum)            │
│  - Pure data structures                 │
│  - Codable conformance                  │
│  - Computed properties only             │
│  - NO logic or side effects             │
└─────────────────────────────────────────┘
```

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

**Unidirectional Data Flow**
```
User Action → View → ViewModel → Service → API
                 ↑                            │
                 └────────────────────────────┘
                      State Update
```

## Key Principles

- **Single Responsibility**: Each file has one clear purpose
- **Separation of Concerns**: Views don't contain business logic
- **Testability**: ViewModels can be tested independently
- **Reusability**: Common components are extracted

## Future Considerations

- Add Repository pattern for data layer
- Implement Coordinator pattern for navigation
- Add dependency injection container
