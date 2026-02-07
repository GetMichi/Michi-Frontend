# Michi

**AI-powered personal finance and budgeting application**

Michi is an iOS-first financial app that combines deterministic budgeting logic with AI-assisted coaching to help users understand and improve their financial health.

---

## About

Michi provides:
- **Intelligent budgeting** powered by rule-based calculation engines
- **AI-powered explanations** that contextualize your spending patterns
- **Secure bank integration** via Plaid
- **Personalized financial coaching** with adaptive tone and insights
- **Real-time financial dashboards** with clear visualizations

### Core Philosophy
- **AI explains, never calculates** — All financial logic is deterministic and auditable
- **iOS-first** — Polished, native experience on Apple platforms
- **Privacy-first** — Your financial data is encrypted and never sold
- **Behavior-focused** — Designed to inform and guide, not overwhelm

---

## Architecture Overview

### Frontend (iOS)
- **Platform**: iOS (Swift)
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Combine
- **Charts**: Apple Charts / SwiftCharts
- **Testing**: XCTest, XCUITest

### Backend (API & Logic)
- **Framework**: Python + FastAPI
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth (Email/password, Apple Sign-In)
- **Business Logic**: Deterministic financial calculation engines
- **AI Orchestration**: OpenAI API (GPT-4+)

### Financial Data
- **Provider**: Plaid (Link SDK)
- **Security**: TLS encryption, token storage in iOS Keychain
- **Data Flow**: Backend-controlled sync and normalization

### Infrastructure
- **Hosting**: Render / Vercel (MVP), AWS/GCP (future)
- **CI/CD**: GitHub Actions
- **Compliance**: GDPR, CCPA aware; educational-only financial guidance

---

## Key Features

### Smart Budgeting
- Automatic budget allocation based on your income and spending patterns
- Real-time tracking of spending vs. budget
- Category-based breakdowns with visual charts

### AI Financial Coach
- Conversational chatbot that explains your finances in plain language
- Adaptive tone: supportive, direct, or neutral
- Context-aware suggestions based on your actual data
- Streaming responses for natural conversation flow

### Bank Integration
- Secure connection to your bank accounts via Plaid
- Automatic transaction syncing
- Balance tracking across multiple accounts

### Financial Insights
- Spending trends over time
- Cashflow projections
- Debt payoff calculations
- Goal progress tracking

### Smart Notifications
- Spending alerts when approaching budget limits
- Goal reminders
- Monthly financial summaries
- **Philosophy**: Inform, don't overwhelm

---

## Technical Stack

### iOS Application
```
Language:       Swift
UI:             SwiftUI (declarative, reactive)
Architecture:   MVVM
Reactive:       Combine
Visualization:  Apple Charts, SwiftCharts
Networking:     URLSession + async/await
Storage:        Keychain (tokens), Supabase (data)
Notifications:  UserNotifications Framework
```

### Backend Services
```
API:            FastAPI (Python)
Database:       PostgreSQL (via Supabase)
Auth:           Supabase Auth
AI:             OpenAI API (GPT-4+)
Financial:      Plaid API
Testing:        Pytest, API validation
```

### Data Flow Architecture
```
iOS App
    ↓
FastAPI Backend
    ↓
┌─────────────────────────────────┐
│ Deterministic Calculation Engine│
│ - Budget allocation             │
│ - Transaction aggregation       │
│ - Cashflow projections          │
│ - Debt payoff calculations      │
└─────────────────────────────────┘
    ↓
Structured Output (JSON)
    ↓
AI Explanation Layer (GPT-4)
    ↓
Natural Language Response
    ↓
iOS Chat UI
```

---

## Getting Started

### Prerequisites
- macOS 14.0+
- Xcode 15.0+
- Swift 5.9+
- iOS 16.0+ target device/simulator
- Active Apple Developer account (for device testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Michi.git
   cd Michi
   ```

2. **Open in Xcode**
   ```bash
   open Michi.xcodeproj
   ```

3. **Configure environment**
   - Add your backend API endpoint to `Config.swift`
   - Ensure proper code signing in Xcode

4. **Build and run**
   - Select iPhone 15 Pro simulator (or your device)
   - Press `Cmd+R`

### Backend Setup
See the [backend repository](https://github.com/YOUR_USERNAME/Michi-Backend) for FastAPI setup instructions.

---

## Project Structure

```
Michi/
├── App/
│   └── MyApp.swift              # App entry point
│
├── Models/
│   ├── Post.swift               # Data models (API responses)
│   └── ...
│
├── Views/
│   ├── ContentView.swift        # Main dashboard
│   ├── ChatView.swift           # AI chatbot interface
│   └── Components/              # Reusable UI components
│
├── ViewModels/
│   ├── BudgetViewModel.swift    # Budget screen logic
│   ├── ChatViewModel.swift      # Chat interface logic
│   └── ...
│
├── Services/
│   ├── NetworkManager.swift     # API client
│   ├── PlaidService.swift       # Plaid integration
│   └── AuthService.swift        # Supabase authentication
│
└──  Utilities/
    ├── Config.swift             # App configuration
    ├── Extensions.swift         # Swift extensions
    └── KeychainManager.swift    # Secure token storage

```

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed design patterns and principles.

---

## Security & Privacy

- **Encryption**: All financial data encrypted at rest and in transit
- **Token Storage**: Plaid and auth tokens stored in iOS Keychain
- **Data Minimization**: Only essential data is collected
- **No Data Selling**: Your financial data is never sold or shared
- **Compliance**: GDPR and CCPA aware

---

## Testing

### Run Unit Tests
```bash
# In Xcode
Cmd+U

# Or via command line
xcodebuild test -scheme Michi -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

### Testing Strategy
- **Unit Tests**: ViewModel logic, data models, utilities
- **UI Tests**: Critical user flows (onboarding, chat, budgets)
- **API Integration Tests**: Backend service mocking

---

## Roadmap

### MVP (Current)
- [x] iOS app with SwiftUI
- [x] Plaid integration
- [x] Basic chatbot interface
- [ ] Budget calculation engine
- [ ] AI coaching explanations
- [ ] Supabase auth & database

### Future
- [ ] Android application
- [ ] Web dashboard
- [ ] Advanced goal tracking
- [ ] Receipt scanning and categorization
- [ ] Multi-currency support
- [ ] Family/shared budgets

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Areas We Need Help
- SwiftUI UI/UX improvements
- Accessibility enhancements
- Testing coverage
- Documentation

---

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

---

## Team
**Product & Engineering**
- [Your Name] - Founder

---

## Documentation

- [Technical Architecture](ARCHITECTURE.md) - Detailed system design
- [Setup Guide](SETUP.md) - Development environment setup
- [Dependencies](DEPENDENCIES.md) - Package management
- [Changelog](CHANGELOG.md) - Version history

---

## Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/Michi/issues)
- **Email**: support@michi.app
- **Documentation**: [docs.michi.app](https://docs.michi.app)

---

**Built with ❤️ for better financial health**

=======
# Plaid Sandbox Demo

## Overview
A simple web application that demonstrates how to use Plaid's sandbox environment. Users can click **Link Bank Account**, connect a test bank account, and view the most recent transactions in a sleek dark‑theme UI.

## Prerequisites
- **Node.js** (v20 or later) – you can verify with `node -v`.
- A Plaid sandbox account. Sign up at https://dashboard.plaid.com and obtain the **Client ID** and **Sandbox Secret**.

## Setup
1. **Clone the repo** (or copy the folder) and `cd` into it:
   ```bash
   cd /Users/kurtis/Michi/SuperSecertTopSecert
   ```
2. **Install dependencies**:
   ```bash
   npm install
   ```
3. **Create a `.env` file** (already present) and fill in your Plaid credentials:
   ```dotenv
   PLAID_CLIENT_ID=your_client_id_here
   PLAID_SECRET=your_sandbox_secret_here
   PLAID_ENV=sandbox
   ```
   *Do not commit this file – it is ignored via `.gitignore`.*

## Running the App
```bash
npm run start
```
The server will start on **http://localhost:3000**. Open that URL in a browser, click **Link Bank Account**, choose a sandbox test user (e.g., `user_good` / `pass_good`), and the recent transactions will appear.

## Project Structure
- `server.js` – Express backend that talks to Plaid.
- `public/` – Front‑end assets (`index.html`, `style.css`, `script.js`).
- `.env` – Holds your Plaid credentials (ignored by Git).
- `.gitignore` – Excludes `node_modules`, `.env`, logs, OS files, etc.
- `requirements.txt` – Lists the npm packages used (for reference).

## License
This demo is provided **as‑is** for learning purposes.
