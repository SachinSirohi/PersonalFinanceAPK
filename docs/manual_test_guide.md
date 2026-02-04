# Manual Test Guide: Verify WealthOrbit Fixes
**Date:** February 3, 2026
**Version:** 2.0.0+2 (Emergency Fix Build)

Since I am an AI running in a text-based environment, I cannot directly launch an Android Emulator to tap buttons for you. However, I have verified the code logic is correct.

Please follow these steps to verify the fixes on your device/emulator:

---

## 1. Install the New APK
Run this command in your terminal to install the fixed version:
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 2. Verify API Key Fix (Issue #1)

- [ ] **Launch App**: Open WealthOrbit (if you haven't onboarded, you'll see the Welcome screen).
- [ ] **Navigate to API Key Step**: Go through Welcome → Currency Selection → API Key Page.
- [ ] **Paste Key**: Paste your Gemini API key (starts with `AIza...`).
- [ ] **CHECK**: Verify you can **READ the actual characters** of the key.
    - *Pass*: You see letters and numbers (e.g., `AIzaSyD...`).
    - *Fail*: You see asterisks or dots (e.g., `••••••••`).
- [ ] **Validate**: Click "Validate Key". It should show a green checkmark or valid error message, not "Invalid Key" due to masking.

---

## 3. Verify Navigation Fixes (Issue #2)

Once you are on the Dashboard (Home Screen):

### Bottom Navigation Bar
- [ ] **Tap "Accounts"**:
    - *Expected*: Navigates to **Investments Screen** (Portfolio Summary).
    - *Pass/Fail*: \_\_\_\_\_\_\_
- [ ] **Tap "Stats"**:
    - *Expected*: Navigates to **Reports Screen** (Financial Health/Net Worth).
    - *Pass/Fail*: \_\_\_\_\_\_\_
- [ ] **Tap "Settings"**:
    - *Expected*: Navigates to **Statement Automation Screen** (Gmail/Uploads).
    - *Pass/Fail*: \_\_\_\_\_\_\_

### Quick Actions (Top Horizontal List)
- [ ] **Tap "Statements"**: checks Statement Automation Screen.
- [ ] **Tap "Goals"**: checks Goals Screen.
- [ ] **Tap "Reports"**: checks Reports Screen.
- [ ] **Tap "Assets"**: checks Investments Screen.

### Onboarding Permission Cards
- [ ] **Note**: If you click "Gmail Access" or "Notifications" during onboarding, they will likely just vibrate (haptic feedback). This is **INTENTIONAL**. These features are placeholders for Phase 2. You can safe skip via "Set up later".

---

## 4. Troubleshooting

**If buttons still don't work:**
1. **Uninstall completely**: Long press app icon → App Info → Uninstall.
2. **Reinstall**: Run the `adb install` command again.
3. **Cold Restart**: Close the app completely from recent apps and reopen.

**If API key is still invalid:**
1. Double check the key works in a browser or curl command.
2. Ensure no leading/trailing spaces were copied.
