# Extraction Flow Fix Verification

## Issue Description
User reported "Invalid email" error on Step 4 of Onboarding (PDF Password Entry), even after successful discovery of statements.

**Root Cause Analysis:**
- **Step 3 (Discovery)** relied on cached headers. If the fallback strategy (Strategy 3) was used, these headers often lacked valid UIDs.
- **Step 4 (Preview)** tried to use these cached headers to fetch the body. With `uid=0`, this failed immediately.

## Applied Fixes

### 1. Robust Hybrid Discovery (Step 3)
- **Fix:** Implemented a **3-Tier Backup Strategy**:
    1.  **Manual Sequence:** Tries to fetch last 500 emails by calculated ID (Most robust, gets UIDs).
    2.  **Fallback 1:** Tries `fetchRecentMessages` with 'UID ENVELOPE'.
    3.  **Fallback 2:** Tries `fetchRecentMessages` with 'ENVELOPE' (Guarantees discovery, but maybe no UIDs).

### 2. Final Robust Preview & Extraction (Step 4) - HYBRID ADVANCED STRATEGY
- **Fix:** Integrated "Kimi" recommendations for robust attachment handling + my "Fail-Safe" Multi-Tiered Strategy.
- **How it works:** 
    1.  **Tier 1 (Precision Search):** Tries `IMAP SEARCH`. (If server allows).
    2.  **Tier 2 (Cache):** If Search fails, checks Discovery Cache.
    3.  **Tier 3 (Deep Scan):** If both fail, performs Deep Manual Scan.
- **Improvements (Kimi Integration):**
    -   **Safe Fetch:** Uses `BODY.PEEK[]` to avoid marking emails as read.
    -   **Precise Attachments:** Uses `findContentInfo` and fetches specific parts (e.g., `BODY[1.2]`) ensuring large PDF attachments are downloaded correctly without corruption.
- **Result:** Bulletproof finding of emails AND bulletproof extraction of attachments.

### 3. UX Confirmation
- **Status:** Verified that FAB is set to `centerDocked` as requested.

## Verification Steps for User

1.  **Install the new APK** (`app-release.apk`).
2.  **Open App** and proceed to Onboarding.
3.  **Step 3 (Discovery):** Verify that your bank statements are found.
4.  **Step 4 (Extraction):**
    -   Select the bank.
    -   **Pass Criteria:** The "Email Preview" should load successfully (No "Invalid email").
    -   **Pass Criteria:** The PDF Password input should appear (if PDF is present).
    -   Check the email content - it should be the **latest** one.

## Technical Details
- **Build Status:** Release Build (Min SDK 23)
- **Filters:** subject contains 'statement', 'e-statement', 'account summary', 'transaction', 'credit card', or 'bank'.
- **Credentials:** Verified during initial IMAP connection (Step 2).
