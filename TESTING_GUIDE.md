# 🧪 Testing & Troubleshooting Guide

## ✅ Pre-flight Checklist

Before testing, make sure:

- [ ] Flutter SDK is installed (`flutter --version`)
- [ ] Android Studio / Xcode is installed
- [ ] Emulator or device connected (`flutter devices`)
- [ ] Dependencies installed (`flutter pub get`)

---

## 🚀 Running the App

### Step 1: Get Dependencies
```bash
cd c:/Users/Assylkhan/Desktop/caterchain_test
flutter pub get
```

### Step 2: Run on Emulator/Device
```bash
# List available devices
flutter devices

# Run app
flutter run

# Run with specific device
flutter run -d <device-id>
```

---

## 🧪 Test Scenarios

### Test 1: Authentication Flow
**Goal**: Verify login/register works

**Steps**:
1. Launch app → should see Login screen
2. Click "Try Demo" → should load demo user
3. See Home screen ✅
4. Go to Profile → logout
5. Should return to Login ✅

**Expected**: Smooth navigation without errors

---

### Test 2: Supplier Links
**Goal**: Verify link request system works

**Steps**:
1. Login with demo user
2. Go to Profile → "Supplier Links"
3. Should see 2 tabs: Connected + Pending
4. Click "+" to request new link
5. Enter Supplier ID: 5
6. See success message ✅

**Expected**: UI updates without crashes

---

### Test 3: Cart & Orders
**Goal**: Verify cart functionality

**Steps**:
1. Home screen → add products to cart
2. Click Cart icon
3. Verify products appear ✅
4. Increase/decrease quantities
5. Click "Place Order"
6. See confirmation ✅

**Expected**: Data persists in localStorage

---

### Test 4: Profile & Logout
**Goal**: Verify user info and logout

**Steps**:
1. Go to Profile
2. Verify user info displays
3. Click Logout
4. Confirm dialog
5. Return to Login screen ✅

**Expected**: User data cleared from localStorage

---

## 🐛 Common Issues & Solutions

### Issue 1: "Emulator connection refused"
**Problem**: Can't connect to backend on localhost
**Solution**: 
- Use `10.0.2.2` instead of `localhost` for Android
- Use `localhost` for iOS
- Update `api_service.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android
static const String baseUrl = 'http://localhost:8000/api'; // iOS
```

### Issue 2: "SharedPreferences not found"
**Problem**: Error when saving user data
**Solution**: 
- Clear app data: `flutter clean && flutter pub get`
- Run: `flutter run`

### Issue 3: "Image loading failed"
**Problem**: Network images not showing
**Solution**:
- Ensure image URLs are valid HTTPS
- Add network permission in AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### Issue 4: "Context is null"
**Problem**: Accessing context in wrong place
**Solution**:
- Always use `mounted` check before using context
- Use `Provider.of(context, listen: false)` in callbacks
```dart
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

### Issue 5: "Widget builds but doesn't update"
**Problem**: State not changing after action
**Solution**:
- Ensure `notifyListeners()` is called in Provider
- Check if using `Consumer` instead of `Provider.of`
- Verify Provider is in MultiProvider tree

---

## 🔍 Debug Tips

### Enable verbose logging
```bash
flutter run -v
```

### Print debugging
```dart
print('Debug: $variable');
print('🔍 User: ${userProvider.currentUser}');
```

### Use DevTools
```bash
flutter pub global activate devtools
devtools
```

---

## 📊 API Debugging

### Using Postman/Insomnia to test API:

1. **Import collection** (if available)
2. **Test endpoints manually**:

```
POST localhost:8000/api/auth/login
Body:
{
  "email": "test@example.com",
  "password": "123456"
}
```

3. **Copy token** from response
4. **Set Authorization** header:
```
Authorization: Bearer {token_from_response}
```

5. **Test protected endpoints**

---

## ✅ Checklist для Production

- [ ] Remove debug prints
- [ ] Test on real device
- [ ] Check all error messages are user-friendly
- [ ] Verify all validations work
- [ ] Test slow network conditions
- [ ] Test with real Backend API
- [ ] Check app size (`flutter build apk --analyze-size`)
- [ ] Enable ProGuard for Android
- [ ] Test on minimum supported OS version
- [ ] Verify all images load
- [ ] Check performance (use Timeline)
- [ ] Security audit of API client

---

## 🔐 Security Checklist

- [ ] Never hardcode API keys
- [ ] Store sensitive data in Secure Storage (not SharedPreferences)
- [ ] Validate all inputs on backend
- [ ] Use HTTPS in production
- [ ] Implement refresh token for JWT
- [ ] Set proper CORS headers
- [ ] Rate limit API endpoints
- [ ] Log security events
- [ ] Regular security audits

---

## 📱 Device-Specific Issues

### Android
- Check `AndroidManifest.xml` for permissions
- Clear build cache: `flutter clean`
- Use Android emulator API 21+

### iOS
- Check `Info.plist` for required keys
- Update Xcode to latest version
- Use iOS 12.0+

---

## 🎯 Performance Tips

1. **Lazy loading** for lists
2. **Image caching** for network images
3. **Pagination** for large datasets
4. **Debouncing** for search inputs
5. **Code splitting** for large files

---

## 📞 Getting Help

When debugging, provide:
1. Error message (full stack trace)
2. Steps to reproduce
3. Device/emulator info
4. Logs from `flutter run -v`
5. Code snippet if applicable

---

**Last Updated**: November 15, 2025
