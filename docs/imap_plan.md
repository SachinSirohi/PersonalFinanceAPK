## IMAP Email Integration - Implementation Guide

### Overview
Switched from Google OAuth to **IMAP with App Passwords** for better simplicity and user control.

### Why IMAP is Better:
1. ✅ **No OAuth verification** - Works immediately
2. ✅ **No Google Cloud setup** - User just creates app password
3. ✅ **Multi-provider support** - Gmail, Outlook, Yahoo, etc.
4. ✅ **More reliable** - Direct IMAP access
5. ✅ **User controls** - Can add multiple accounts

### User Flow:
1. User taps "Email Access" in onboarding
2. Enters:
   - Email address
   - App password (Gmail: myaccount.google.com/apppasswords)
   - Provider (Gmail/Outlook/Yahoo)
3. App stores credentials securely
4. Background service uses IMAP to fetch statements

### Files Modified:
- ✅ `onboarding_screen.dart` - Removed OAuth, added email config button
- ✅ `secure_vault.dart` - Added email credentials storage  
- ⏳ Need to add `_showEmailConfigSheet()` method
- ⏳ Need to create IMAP service

### Package Needed:
```yaml
dependencies:
  enough_mail: ^2.1.7  # IMAP/SMTP client
```
