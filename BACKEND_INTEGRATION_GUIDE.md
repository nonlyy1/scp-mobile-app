# Backend Integration Guide

**Purpose:** Step-by-step instructions for connecting the mobile app to real Backend API  
**Target Date:** November 16-18, 2025  
**Estimated Time:** 2-3 days

---

## Phase 1: Backend Verification (30 min)

### Step 1.1: Verify Backend Server
```bash
# Check Backend is running
curl http://localhost:8000/health

# Expected response:
# {"status": "ok"}
```

### Step 1.2: Verify Database
- [ ] PostgreSQL running
- [ ] Database created and migrations applied
- [ ] Tables exist: users, suppliers, products, orders, chats, complaints
- [ ] Sample data inserted

### Step 1.3: Check API Documentation
- [ ] Endpoint list matches `BACKEND_API_SPEC.md`
- [ ] Request/response formats verified
- [ ] Error codes documented
- [ ] Authentication method confirmed (JWT)

---

## Phase 2: API Configuration (15 min)

### Step 2.1: Update Base URL

**File:** `lib/services/api_service.dart`

Find this line:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

For different environments:
```dart
// Local development
static const String baseUrl = 'http://localhost:8000/api';

// Staging
static const String baseUrl = 'https://staging-api.caterchain.com/api';

// Production
static const String baseUrl = 'https://api.caterchain.com/api';
```

### Step 2.2: Add Environment Configuration

Create `lib/config/app_config.dart`:

```dart
class AppConfig {
  static const bool useRealApi = true;  // Set to false for mock data
  static const bool debugLogging = true;  // Enable API request logging
  
  static String getBaseUrl({required String environment}) {
    switch (environment) {
      case 'local':
        return 'http://localhost:8000/api';
      case 'staging':
        return 'https://staging-api.caterchain.com/api';
      case 'production':
        return 'https://api.caterchain.com/api';
      default:
        return 'http://localhost:8000/api';
    }
  }
}
```

---

## Phase 3: Testing Authentication (1 hour)

### Step 3.1: Test Login Endpoint

**Endpoint:** `POST /auth/login`  
**Expected Request:**
```json
{
  "email": "test@example.com",
  "password": "password123"
}
```

**Expected Response:**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "test@example.com",
    "company_name": "ABC Restaurant"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Step 3.2: Verify Token Storage

Test in app:
1. Open LoginScreen
2. Enter credentials
3. Click Login
4. Check that token is stored in `ApiService._authToken`
5. Verify token sent in subsequent API requests

### Step 3.3: Test Logout

Verify:
- [ ] Token cleared from storage
- [ ] App redirects to LoginScreen
- [ ] Subsequent requests fail without token

---

## Phase 4: Testing Endpoints (Full Day)

### Step 4.1: Authentication Endpoints

**Test:** UserProvider methods

```dart
// Test login
await userProvider.login(
  email: 'test@example.com',
  password: 'password123',
);

// Test register
await userProvider.registerConsumer(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  phone: '+77771234567',
  companyName: 'ABC Restaurant',
);

// Test logout
await userProvider.logout();
```

**Checklist:**
- [ ] Login works with valid credentials
- [ ] Register creates new user
- [ ] Invalid credentials show error
- [ ] Logout clears token
- [ ] Re-login after logout works

### Step 4.2: Supplier Link Endpoints

**Test:** SupplierLinkProvider methods

```dart
// Load links
await linkProvider.loadLinks();

// Request new link
await linkProvider.requestSupplierLink(
  supplierId: 2,
  supplierName: 'Fresh Supplier Co',
  message: 'Request to connect',
);
```

**Checklist:**
- [ ] Load links returns correct data
- [ ] Connected suppliers filtered correctly
- [ ] Pending requests filtered correctly
- [ ] New request sends to Backend
- [ ] Status updates reflected in UI

### Step 4.3: Product Endpoints

**Test:** ProductProvider methods

```dart
// Load products
await productProvider.loadProducts();

// Get featured products
final featured = productProvider.featuredProducts;

// Filter by supplier
final supplierProducts = productProvider.getProductsBySupplier(supplierId: 1);
```

**Checklist:**
- [ ] Products load from Backend
- [ ] Correct number of products
- [ ] Product details match Backend data
- [ ] Images display correctly
- [ ] Prices accurate

### Step 4.4: Order Endpoints

**Test:** OrderProvider methods

```dart
// Create order
await orderProvider.createOrder(
  supplierId: 1,
  items: cartItems,
  deliveryAddress: 'Main St, Apt 101',
);

// Get orders
await orderProvider.loadOrdersFromBackend();
```

**Checklist:**
- [ ] Create order succeeds
- [ ] Order appears in history
- [ ] Status updates from Backend
- [ ] Total price calculated correctly

### Step 4.5: Chat Endpoints

**Test:** ChatProvider methods

```dart
// Load chats
await chatProvider.loadChats();

// Send message
await chatProvider.sendMessage(
  chatId: 1,
  message: 'Hello, can you confirm this order?',
);

// Mark as read
await chatProvider.markMessageAsRead(chatId: 1, messageId: 5);
```

**Checklist:**
- [ ] Chats load from Backend
- [ ] Messages send successfully
- [ ] Messages appear in thread
- [ ] Unread count updates
- [ ] Real-time updates work (if WebSocket)

### Step 4.6: Complaint Endpoints

**Test:** ComplaintProvider methods

```dart
// Load complaints
await complaintProvider.loadComplaints();

// Create complaint
await complaintProvider.createComplaint(
  orderId: 10,
  description: 'Items arrived damaged',
);
```

**Checklist:**
- [ ] Complaints load from Backend
- [ ] New complaints save to Backend
- [ ] Status updates work
- [ ] Filtering by status works

---

## Phase 5: Error Handling (1 hour)

### Step 5.1: Test Error Scenarios

Test with invalid data:

```dart
// Invalid email
await userProvider.login(email: 'invalid', password: 'pass');
// Expected: "Please enter a valid email"

// Server error
// Disconnect Backend
// Expected: "Cannot connect to server - check your internet"

// Network timeout
// Set slow connection
// Expected: "Request timeout - please try again"
```

### Step 5.2: Verify Error Messages

Check that:
- [ ] API errors are user-friendly
- [ ] Network errors suggest solutions
- [ ] Validation errors are clear
- [ ] Error messages appear in SnackBar
- [ ] Errors don't crash app

### Step 5.3: Test Recovery

- [ ] App recovers from temporary network error
- [ ] User can retry failed operations
- [ ] Token refresh works if expired
- [ ] App doesn't show stale data after error

---

## Phase 6: Performance Testing (2 hours)

### Step 6.1: Load Testing

- [ ] App handles 100+ products
- [ ] Chat with 50+ messages loads quickly
- [ ] Lists scroll smoothly
- [ ] No memory leaks with large datasets

### Step 6.2: Network Testing

Simulate conditions:
```bash
# Slow network
adb shell settings put global http_proxy 127.0.0.1:8888

# Offline
adb shell settings put global airplane_mode_on 1

# Check app handles gracefully
```

### Step 6.3: Analytics

Measure:
- [ ] Average API response time
- [ ] Error rate
- [ ] User action completion rate
- [ ] Screen load time

---

## Phase 7: Security Verification (1 hour)

### Step 7.1: Token Security

- [ ] Token not visible in logs
- [ ] Token cleared on logout
- [ ] Token expires (if implemented)
- [ ] Token included in all authenticated requests

### Step 7.2: Data Security

- [ ] HTTPS enforced in production
- [ ] Sensitive data encrypted
- [ ] No passwords stored locally
- [ ] API responses sanitized

### Step 7.3: Input Validation

- [ ] All user inputs validated
- [ ] SQL injection prevented
- [ ] XSS prevented
- [ ] CSRF tokens used (if applicable)

---

## Phase 8: Device Testing (2 hours)

### Step 8.1: Android Testing

```bash
# Build APK
flutter build apk --release

# Install on device
adb install build/app/outputs/apk/release/app-release.apk

# Test on Android 8, 10, 12, 14
```

### Step 8.2: iOS Testing

```bash
# Build IPA
flutter build ios --release

# Install via TestFlight or physical device
```

### Step 8.3: Test Matrix

| Feature | Phone | Tablet | Landscape | Offline |
|---------|-------|--------|-----------|---------|
| Login | ✓ | ✓ | ✓ | - |
| Products | ✓ | ✓ | ✓ | Mock |
| Chat | ✓ | ✓ | ✓ | - |
| Orders | ✓ | ✓ | ✓ | - |
| Complaints | ✓ | ✓ | ✓ | - |

---

## Phase 9: User Acceptance Testing (1 hour)

### Step 9.1: End-to-End Workflows

1. **Complete Order Workflow**
   - [ ] Login as consumer
   - [ ] View products from connected supplier
   - [ ] Add to cart
   - [ ] Checkout
   - [ ] View order in history
   - [ ] Chat with supplier
   - [ ] Complete order

2. **Complaint Workflow**
   - [ ] Create complaint for completed order
   - [ ] Add description and priority
   - [ ] See complaint in open tab
   - [ ] Check status updates

3. **Supplier Connection Workflow**
   - [ ] Request new supplier link
   - [ ] View pending request
   - [ ] (Backend: Accept link)
   - [ ] See in connected suppliers
   - [ ] View their products

### Step 9.2: User Feedback

- [ ] Collect feedback from 5-10 test users
- [ ] Document any issues
- [ ] Prioritize fixes

---

## Phase 10: Production Deployment (1 hour)

### Step 10.1: Pre-Release Checklist

- [ ] All tests passing
- [ ] No console errors
- [ ] Performance acceptable
- [ ] Security verified
- [ ] Documentation updated
- [ ] Version bumped in pubspec.yaml

### Step 10.2: Update Configuration

```dart
// production/main.dart
const String API_BASE_URL = 'https://api.caterchain.com/api';
const bool DEBUG_MODE = false;
const bool USE_MOCK_DATA = false;
```

### Step 10.3: Build Release

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web (if applicable)
flutter build web --release
```

### Step 10.4: Deploy

- [ ] Upload APK to Google Play Store
- [ ] Upload IPA to Apple App Store
- [ ] Submit for review
- [ ] Monitor for crashes

---

## Rollback Plan

If issues found in production:

1. **Immediate:** Disable affected feature in Backend
2. **Within 1 hour:** Deploy hotfix
3. **Communication:** Notify users of issues
4. **Analysis:** Debug logs from crash reporting
5. **Fix & Re-deploy:** Within 24 hours

---

## Success Criteria

### All tests must pass:
- [ ] Authentication works
- [ ] All CRUD operations successful
- [ ] Error handling robust
- [ ] Performance acceptable
- [ ] No crashes
- [ ] Data consistency

### Acceptance:
- [ ] Backend team approves
- [ ] QA team signs off
- [ ] Product owner approves
- [ ] Ready for production

---

## Support Resources

### If you encounter issues:

1. **Check Documentation**
   - BACKEND_API_SPEC.md - Endpoint details
   - TESTING_GUIDE.md - Troubleshooting
   - IMPLEMENTATION_GUIDE.md - Architecture

2. **Check Logs**
   - Flutter console: `flutter logs`
   - Backend logs: Check server logs
   - Network logs: Use Charles/Fiddler

3. **Common Issues**
   - **401 Unauthorized:** Token expired or invalid
   - **404 Not Found:** Endpoint doesn't exist
   - **500 Internal Error:** Backend error (check logs)
   - **No Network:** Check internet connection

---

**Timeline:** November 16-18, 2025  
**Status:** Ready for Backend Integration  
**Approval:** Backend team to confirm readiness
