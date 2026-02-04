# Project Handover & AI Context

## Project Overview
**Name:** Personal Finance App (Project Copilot)
**Tech Stack:** Flutter (Mobile), Dart
**State:** Pre-Release (Release APK Built)
**Key Feature:** Automated Bank Statement Analysis via Gmail using Gemini AI.

## Core Objectives
1.  **Secure Authentication:** Users log in securely.
2.  **Statement Discovery:** App scans Gmail (IMAP) for bank statements.
3.  **PDF Extraction:** Downloads PDF statements (using a robust Multi-Tier Strategy).
4.  **AI Analysis:** Extracts financial data from PDFs using Google Gemini Flash 2.0.
5.  **Financial Dashboard:** Displays Insights, Net Worth, Expenses, and Investment projections.

## Recent Major Changes (Critical Context)
-   **IMAP Extraction Overhaul:** We recently rewrote `ImapService.dart` to solve a persistent "No Emails Found" error.
    -   *Old Logic:* Relied solely on `IMAP SEARCH`, which failed unpredictably.
    -   *New Logic:* Uses a **Multi-Tier Fallback Strategy**:
        1.  **Tier 1:** Server Search (Precision).
        2.  **Tier 2:** Cache Check (If Discovery found it, use that UID). **<-- This fixed the issue.**
        3.  **Tier 3:** Deep Scan (Last 500 emails).
-   **Attachment Handling:** Integrated robust `BODY.PEEK[]` and `findContentInfo` logic to prevent PDF corruption and avoid marking emails as read.
-   **Gemini Model:** Switched to `gemini-2.0-flash-exp` for better performance.
-   **Architecture:**
    -   `ImapService`: Handles email connection and searching.
    -   `GmailService`: Orchestrates the flow (Discovery -> Password -> Extraction).
    -   `GeminiService`: Handles AI analysis.
    -   `SecureVault`: Stores credentials via `flutter_secure_storage`.

## Current Status
-   **Build:** `app-release.apk` is built and functional.
-   **Codebase:** Clean (passing `flutter analyze`).
-   **Known Issues:** None currently. The "No Emails Found" blocker is resolved.

## Directory Structure Highlights
-   `lib/data/services/`: Core logic (IMAP, Gmail, Gemini, Database).
-   `lib/features/`: UI Screens grouped by feature (Onboarding, Dashboard, etc.).
-   `docs/`: Contains all comprehensive analysis, verify guides, and architectural decisions.

## Instructions for Next AI
If you are picking up this project:
1.  **Read `docs/walkthrough.md`** first to understand the recent flow validation.
2.  **Review `docs/extraction_fix_verification.md`** to understand the critical IMAP logic.
3.  **Do NOT revert `ImapService.dart`** to a simple search without checking the `Step 4` history. The fallback logic is essential.
