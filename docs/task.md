# Project Tasks: Gap Remediation & Optimization

## Phase 1: Discovery & Extraction Flow ✅ COMPLETE
- [x] Add `discoverStatementSenders()` to `ImapService`
- [x] Create `DiscoveredSource` model with bank name detection
- [x] Create `StatementDiscoveryScreen` UI
- [x] Create `PasswordCollectionScreen` UI with robust verification
- [x] Create `ExtractionProgressScreen` UI
- [x] Build and Verify APK

## Phase 2: Gap Analysis & Code Review ✅ COMPLETE
- [x] Analyze codebase against BRD
- [x] Identify critical disconnects (Background Service)
- [x] Identify missing features (Goals, Reports, Exit Rules)
- [x] Create Comprehensive Gap Analysis Report

## Phase 3: Critical Fixes ✅ COMPLETE
- [x] **Fix Background Automation (P0)**
    - [x] Refactor `BackgroundService` to use `ImapService`
    - [x] Check for method name alignment (`extractText`)
    - [x] Fix missing `await` in async calls
    - [x] Add `ExitRulesService.evaluateAllRules()` to background task
    - [x] Add `showExitRuleTriggered` notification method
- [x] **Implement Goal Logic (P0)**
    - [x] Goals already use `FinancialCalculations` for SIP calculations
    - [x] Added inflation-adjusted target calculation (6% default)
    - [x] `GoalDetailSheet` implements linked assets, SIP recommendation, what-if analysis
- [x] **Implement Reporting (P1)**
    - [x] Created `PdfReportService` with Financial Summary and Annual Report
    - [x] Added PDF export button to `ReportsScreen`
    - [x] Added `share_plus` dependency for sharing reports

## Phase 4: UX & Final Polish (Current)
- [ ] **Main Layout Fix**
    - [ ] Move Floating Action Button (FAB) to Center Docked position
    - [ ] Align with Bottom Navigation Bar
- [ ] **Expenses Screen UX**
    - [ ] Add "Add Expense" button (in addition to "Set Budget")
- [ ] **Build Final APK**
    - [x] Run `flutter build apk` <!-- id: 52 -->

## Phase 5: Final Validation ✅ COMPLETE
- [x] **Code Re-analysis**
    - [x] Audit Service Layer (`BackgroundService`, `ExitRules`).
    - [x] Verify BRD Compliance.
    - [x] Generate [Final Gap Analysis](file:///Users/sachinsirohi/.gemini/antigravity/brain/fffd2477-0bfb-4c96-87aa-1796e2873dca/final_gap_analysis.md).
- [x] **Fix Extraction Flow**
    - [x] Fix "Invalid Email" error (Ensure UID fetch).
    - [x] Sort statements by latest (Newest First).
    - [x] Verify centered FAB in Main Layout.
    - [x] **Regression Fix:** Restore Discovery (Manual Sequence Fetch).
    - [x] **Step 4 Final Fix:** Kimi Integration (PEEK/Parts) + Multi-Tier Fallback.

## Deferred / Skipped (User Approved)
- [ ] **Smart Categorization (Manual)** - Skipping to save API usage
- [ ] **Security Hardening** - Deferred for later

## Files Modified/Created This Session
| File | Status | Description |
|:---|:---:|:---|
| `task.md` | ✏️ Updated | Scoped down based on user feedback |
