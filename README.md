# WealthOrbit 🌍💰

**WealthOrbit** is a comprehensive, privacy-first Personal Finance Command Center built with Flutter. It goes beyond simple expense tracking to provide institutional-grade financial analysis, net worth tracking, and automated wealth management tools for global investors.

## 🚀 Key Features

### 1. 📊 Interactive Dashboard
- **Net Worth Tracking**: Real-time aggregation of assets and liabilities.
- **Emergency Fund Status**: Visual progress towards your safety net goal (months of coverage).
- **Financial Health Score**: AI-driven analysis of your financial stability.
- **Quick Actions**: One-tap access to assets, goals, and statements.

### 2. 🧮 Advanced Financial Tools
- **Deep Calculations**: Built-in specialized calculators for XIRR, SIP, IRR, NPV, and EMI.
- **SIP Planner**: Calculate monthly investments needed to reach specific goals based on expected returns.
- **Scenario Modeling**: "What-If" analysis to compare Conservative (6%), Moderate (10%), and Aggressive (15%) return outcomes.

### 3. 🏠 Real Estate Manager
- **Property Portfolio**: Track multiple properties with purchase details and current valuation.
- **Deal Analyzer**: sophisticated ROI, Cap Rate, and Net Yield calculator for potential investments.
- **P&L Tracking**: Record rental income and property expenses to monitor Net Operating Income (NOI).

### 4. 📈 Investment Command Center
- **SIP Management**: Track all Systematic Investment Plans, pause/active status, and historical performance.
- **Dividend Tracker**: Log dividend payouts with year-wise filtering and DRIP (Dividend Reinvestment) support.
- **Asset Allocation**: Visual breakdown of your portfolio across different asset classes.

### 5. 🎯 Goal Planning
- **Goal-Asset Linking**: Directly link specific investments to financial goals (e.g., "Retirement Fund" linked to "ETF Portfolio").
- **Progress Tracking**: Visual progress bars and shortfall analysis.
- **Smart Recommendations**: Auto-suggested contribution increases to meet target dates.

### 6. 🤖 Statement Automation
- **Gmail Sync**: Secure OAuth integration to fetch financial statements automatically.
- **Smart Parsing**: Automated extraction of transaction data from bank PDF statements.
- **Privacy First**: All parsing happens locally or securely; no financial data leaves your device.
- **Manual Upload**: Support for manually uploading statement PDFs for processing.

---

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Database**: Drift (SQLite) for robust offline-first data persistence.
- **Charts**: FL Chart for beautiful, animated visualizations.
- **UI/UX**: Custom design system with Google Fonts (Poppins/Inter) and Glassmorphism elements.

---

## 📲 Getting Started

### Prerequisites
- Flutter SDK (v3.10+)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/wealth-orbit.git
   cd wealth-orbit
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building Release APK
To generate the production Android package:

```bash
flutter build apk --release
```
The output file will be located at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔒 Privacy & Security

WealthOrbit is designed with a "Local-First" philosophy.
- **Local Database**: Your financial data resides in an encrypted SQLite database on your device.
- **Direct Processing**: Statement parsing logic runs within the app environment.
- **No External Servers**: We do not store your financial data on cloud servers.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
