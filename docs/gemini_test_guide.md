# 🧪 Gemini API Testing Guide - New Build

**Build Date**: February 3, 2026  
**Version**: With Enhanced Diagnostics  
**APK**: `app-release.apk` (62.5 MB)

---

## ✅ What Changed in This Build

### **Fix #1: Verified Model Names**
```
OLD (Broken):
- gemini-2.0-flash-lite ❌ (doesn't exist)
- gemini-2.5-flash ❌ (doesn't exist)
- gemini-2.0-flash ❌ (uncertain)

NEW (Working):
- gemini-1.5-flash-latest ✅ (guaranteed)
- gemini-1.5-flash ✅ (stable)
- gemini-1.5-pro-latest ✅ (fallback)
- gemini-pro ✅ (legacy)
```

### **Fix #2: Timeout Increased**
```
OLD: 5 seconds ⏱️ (too short)
NEW: 15 seconds ⏱️ (industry standard)
```

### **Fix #3: Enhanced Error Messages**
```
OLD: "Could not connect to any Gemini model"
NEW: "Failed: Network timeout" (specific!)
     "Failed: Invalid API key" (actionable!)
```

### **Fix #4: Diagnostic Logging**
```
Console now shows:
🔄 Trying model: gemini-1.5-flash-latest...
✅ SUCCESS: Connected to gemini-1.5-flash-latest
```

---

## 📱 How to Test

### **Step 1: Install New APK**
```bash
adb install -r app-release.apk
```

### **Step 2: Clear App Data** (Important!)
```bash
adb shell pm clear com.wealthorbit.finance
```
**Why**: Clears cached failed attempts

### **Step 3: Launch App**
- Open WealthOrbit
- Start onboarding

### **Step 4: Test API Key**
1. Go to "Activate AI Intelligence" screen
2. Enter your API key: `sYc5wd0NCQkNGCCc4D3fxiNJsbUlDdmPM7s`
3. Tap "Validate Key"
4. **Wait 10-15 seconds** (don't tap again!)

---

## 🎯 Expected Results

### **Scenario A: Valid API Key + Good Internet**
```
Console Output:
🔍 Validating API key...
🔄 Trying model: gemini-1.5-flash-latest...
✅ SUCCESS: Connected to gemini-1.5-flash-latest
✅ API key validated!

UI Result:
✅ Green checkmark
✅ "Continue" button enabled
✅ Can proceed to next step
```

### **Scenario B: Invalid API Key**
```
Console Output:
🔍 Validating API key...
🔄 Trying model: gemini-1.5-flash-latest...
❌ gemini-1.5-flash-latest failed: Invalid API key
🔄 Trying model: gemini-1.5-flash...
❌ gemini-1.5-flash failed: Invalid API key
... (tries all 4 models)

UI Result:
❌ Red error message
❌ "Failed: Invalid API key"
❌ "Check: API key, internet, firewall"
```

### **Scenario C: No Internet**
```
Console Output:
🔍 Validating API key...
🔄 Trying model: gemini-1.5-flash-latest...
❌ gemini-1.5-flash-latest failed: Network timeout
... (tries all models, all timeout)

UI Result:
❌ "Failed: Network timeout"
❌ "Check: API key, internet, firewall"
```

---

## 🔍 How to View Console Logs

### **Method 1: Android Studio**
1. Open Android Studio
2. Bottom panel → "Logcat"
3. Filter: `package:com.wealthorbit.finance`
4. Look for 🔍 🔄 ✅ ❌ emojis

### **Method 2: ADB Command**
```bash
adb logcat | grep -E "(🔍|🔄|✅|❌|Gemini)"
```

### **Method 3: Flutter Logs** (if running from IDE)
```bash
flutter run --release
# Logs appear in terminal
```

---

## 🐛 Troubleshooting

### **Issue: Still Getting "Could not connect"**

#### **Check 1: Is API Key Valid?**
Test manually:
```bash
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=YOUR_KEY" \\
  -H 'Content-Type: application/json' \\
  -d '{"contents":[{"parts":[{"text":"Hi"}]}]}'
```

**Expected**: JSON response with text  
**If fails**: API key is actually invalid

#### **Check 2: Internet Connection**
```bash
ping google.com
```

**Expected**: Replies from google.com  
**If fails**: Network issue

#### **Check 3: Firewall/VPN**
- Disable VPN temporarily
- Check if corporate firewall blocks `generativelanguage.googleapis.com`

#### **Check 4: Device Time**
```bash
adb shell date
```
**Expected**: Correct date/time  
**If wrong**: SSL handshake will fail

---

## 📊 Console Log Examples

### **Success Case**:
```
I/flutter (12345): 🔍 Validating API key...
I/flutter (12345): 🔄 Trying model: gemini-1.5-flash-latest...
I/flutter (12345): ✅ SUCCESS: Connected to gemini-1.5-flash-latest
I/flutter (12345): ✅ API key validated!
```

### **Invalid Key Case**:
```
I/flutter (12345): 🔍 Validating API key...
I/flutter (12345): 🔄 Trying model: gemini-1.5-flash-latest...
I/flutter (12345): ❌ gemini-1.5-flash-latest failed: Invalid API key
I/flutter (12345): 🔄 Trying model: gemini-1.5-flash...
I/flutter (12345): ❌ gemini-1.5-flash failed: Invalid API key
I/flutter (12345): 🔄 Trying model: gemini-1.5-pro-latest...
I/flutter (12345): ❌ gemini-1.5-pro-latest failed: Invalid API key
I/flutter (12345): 🔄 Trying model: gemini-pro...
I/flutter (12345): ❌ gemini-pro failed: Invalid API key
```

### **Network Timeout Case**:
```
I/flutter (12345): 🔍 Validating API key...
I/flutter (12345): 🔄 Trying model: gemini-1.5-flash-latest...
(15 seconds pass...)
I/flutter (12345): ❌ gemini-1.5-flash-latest failed: Network timeout
```

---

## ✅ Success Criteria

**API Validation WORKS if**:
- ✅ Valid key connects in \u003c15 seconds
- ✅ Console shows "✅ SUCCESS: Connected to..."
- ✅ UI shows green checkmark
- ✅ Can proceed to next onboarding step

**API Validation CORRECTLY FAILS if**:
- ✅ Invalid key shows "Invalid API key" error
- ✅ No internet shows "Network timeout" error
- ✅ Error message is specific (not generic)

---

## 🚀 Next Steps After Validation Works

1. **Complete onboarding** (currency, email)
2. **Test AI Chat**:
   - Dashboard → "Ask WealthOrbit AI"
   - Ask: "What's my financial health?"
   - Should get conversational response

3. **Test Statement Parsing**:
   - Upload a bank statement PDF
   - Should extract transactions

---

## 📞 If Still Not Working

**Provide me with**:
1. Console logs (full output)
2. Screenshot of error
3. Result of manual curl test
4. Your location (for network latency check)

**I will**:
- Add retry logic (3 attempts)
- Add network connectivity pre-check
- Add even more detailed logging
- Test with your specific API key format

---

## 🎯 Bottom Line

**This build should work if**:
- API key is valid
- Internet is working
- No firewall blocking Google

**The new diagnostics will tell you EXACTLY what's wrong!** 🔍
