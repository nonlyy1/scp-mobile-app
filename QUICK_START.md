# 🚀 Quick Start Guide - CaterChain SCP

## ⚡ 5-Minute Setup

### 1. Prepare Environment
```bash
# Navigate to project
cd c:/Users/Assylkhan/Desktop/caterchain_test

# Get dependencies
flutter pub get

# Clean (if needed)
flutter clean
flutter pub get
```

### 2. Run the App
```bash
# Run on connected device/emulator
flutter run

# Or run with verbose output for debugging
flutter run -v
```

### 3. Test Immediately
- App opens → you see **Login Screen**
- Click **"📱 Try Demo"** button
- Enter **Demo Mode** automatically
- See **Home Screen** with products ✅

---

## 🧪 Test Different Flows (5 mins each)

### Flow 1: Demo Mode
```
🔘 Try Demo button
→ Auto-login as demo user
→ Home screen with products
→ Add to cart
→ View profile
→ Logout → back to login
Time: 2 mins
```

### Flow 2: Full Registration
```
🔗 Sign Up link on login
→ Fill registration form
→ Click "Create Account"
→ See success message
→ Auto-login after registration
Time: 3 mins
```

### Flow 3: Supplier Links
```
👤 Profile → Supplier Links
→ See 2 tabs: Connected + Pending
→ Click "+" to add new link
→ Send request dialog
→ See mock data populated
Time: 2 mins
```

### Flow 4: Shopping & Cart
```
🛒 Home → Add products to cart
→ Cart icon → View cart
→ Modify quantities
→ Place order → Success message
Time: 2 mins
```

---

## 📋 Checklist Before Going to Production

- [ ] Test on Android device (not just emulator)
- [ ] Test on iOS device (if applicable)
- [ ] Verify all screens load without errors
- [ ] Check network error handling
- [ ] Test with real Backend API
- [ ] Verify token persistence on app restart
- [ ] Test logout and login flow
- [ ] Verify images load from network
- [ ] Check permission requests (camera, storage)
- [ ] Test on low internet speed

---

## 🔗 Backend Integration Checklist

### Before connecting Backend:

1. **Backend must be running**
   ```bash
   # Example (Django)
   python manage.py runserver 0.0.0.0:8000
   ```

2. **Update API URL in code**
   - File: `lib/services/api_service.dart`
   - Change: `static const String baseUrl = ...`
   - For Android emulator: `http://10.0.2.2:8000/api`
   - For iOS: `http://localhost:8000/api`

3. **Backend must have these endpoints**
   - See `BACKEND_API_SPEC.md` for full list
   - Minimum: `/auth/login`, `/auth/register`

4. **Test endpoints with Postman first**
   - Create Postman collection
   - Test all endpoints manually
   - Verify request/response format

5. **Then test in app**
   - Try login with real Backend
   - Check token is saved
   - Verify user data loads

---

## 🐛 Quick Troubleshooting

### "Build failed"
```bash
flutter clean
flutter pub get
flutter run
```

### "Can't connect to Backend"
```dart
// In api_service.dart, use correct IP:
// Android emulator: 10.0.2.2
// iOS simulator: localhost
// Physical device: your-computer-ip:8000
```

### "SharedPreferences error"
```bash
flutter pub get
flutter run
# Clear app data from device settings
```

### "Images not loading"
- Check image URL is HTTPS
- Add internet permission to AndroidManifest.xml
- Check network connectivity

### "Endless loading"
- Check Backend API is running
- Verify API_URL in code
- Check network connectivity
- Look at logs: `flutter run -v`

---

## 📁 Key Files Reference

| File | Purpose | Edit For |
|------|---------|----------|
| `main.dart` | Entry point | Navigation, themes |
| `api_service.dart` | API client | Backend endpoints, URL |
| `user_provider.dart` | Auth logic | Auth flow changes |
| `login_screen.dart` | Login UI | UI/UX modifications |
| `pubspec.yaml` | Dependencies | Add new packages |

---

## 🎯 Common Tasks

### Task 1: Add a new API endpoint
1. Add method in `ApiService` class
2. Call it from appropriate Provider
3. Handle response in UI

### Task 2: Add a new screen
1. Create `new_screen.dart`
2. Add route in `main.dart`
3. Navigate from existing screen

### Task 3: Change app theme
1. Edit `main.dart` theme section
2. Update colors: `Color(0xFF6B8E23)` ← change this
3. Update fonts if needed

### Task 4: Add local data persistence
1. Use `DatabaseHelper.saveUser()` for storage
2. Use `DatabaseHelper.getUser()` to retrieve
3. Clear with `DatabaseHelper.logoutUser()`

---

## 📱 Architecture Summary

```
┌─────────────────────────────────────┐
│         UI Layer (Screens)          │ ← What user sees
├─────────────────────────────────────┤
│   State Management (Providers)      │ ← Business logic
├─────────────────────────────────────┤
│     API Service / Database          │ ← Data layer
├─────────────────────────────────────┤
│   Backend API / Local Storage       │ ← Data source
└─────────────────────────────────────┘
```

---

## 📊 Performance Tips

1. **Use `const` constructors** - faster rebuilds
2. **Lazy load** lists with `ListView.builder()`
3. **Cache images** - use `CachedNetworkImage`
4. **Debounce search** - use `Timer.periodic()`
5. **Unsubscribe streams** - prevent memory leaks

---

## 🔐 Security Reminder

✅ DO:
- [ ] Hash passwords on Backend
- [ ] Use HTTPS in production
- [ ] Validate inputs on Backend
- [ ] Use JWT with short expiration
- [ ] Store sensitive data in Secure Storage

❌ DON'T:
- [ ] Hardcode API keys
- [ ] Store passwords in client
- [ ] Log sensitive data
- [ ] Use HTTP in production
- [ ] Trust client-side validation alone

---

## 📞 Quick Help

### Debug Logs
```bash
flutter run -v
# Look for HTTP requests/responses
```

### Run Tests
```bash
flutter test
```

### Build for Android
```bash
flutter build apk
```

### Build for iOS
```bash
flutter build ios
```

---

## 💡 Pro Tips

1. **Use "Try Demo" first** - fast way to test UI without Backend
2. **Keep API_SERVICE centralized** - all API calls in one place
3. **Use error messages from Backend** - show them to user
4. **Log everything during development** - helps debugging
5. **Test on real device** - emulator doesn't catch all issues

---

## 🎓 Learning Resources

- **Flutter Official**: https://flutter.dev
- **Provider Pattern**: https://pub.dev/packages/provider
- **HTTP Package**: https://pub.dev/packages/http
- **SharedPreferences**: https://pub.dev/packages/shared_preferences

---

## 📅 Timeline Reference

| Date | Milestone |
|------|-----------|
| Nov 15, 2025 | ✅ Auth system complete |
| Nov 16, 2025 | 📅 Chat system |
| Nov 17, 2025 | 📅 Complaints system |
| Nov 18, 2025 | 📅 Backend integration |
| Nov 19, 2025 | 📅 Testing & QA |
| Nov 20, 2025 | 📅 **MVP Launch** 🎉 |

---

## ✅ Final Checklist Before Shipping

- [ ] No console errors/warnings
- [ ] All screens tested
- [ ] Back button works everywhere
- [ ] Loading states implemented
- [ ] Error messages user-friendly
- [ ] Images load correctly
- [ ] Logout/login cycle works
- [ ] App doesn't crash on slow network
- [ ] Permissions requested properly
- [ ] Code is well-commented
- [ ] All TODOs completed
- [ ] Performance is acceptable

---

**You're all set! 🚀**

Questions? Check the docs:
- Implementation details → `IMPLEMENTATION_GUIDE.md`
- API reference → `BACKEND_API_SPEC.md`
- Testing guide → `TESTING_GUIDE.md`
- Project structure → `PROJECT_STRUCTURE.md`

Happy coding! 🎉

---

**Last Updated**: November 15, 2025
