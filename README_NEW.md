# 🍽️ CaterChain SCP - Mobile Application

**Supplier Consumer Platform (SCP)** - B2B mobile application for food supply chain management between suppliers and institutional consumers (restaurants, hotels).

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-MVP--In--Development-orange.svg)

---

## 📋 Project Overview

CaterChain SCP is a **B2B digital platform** enabling:
- ✅ Direct supplier-consumer relationships
- ✅ Controlled catalog access (link-based)
- ✅ Order creation and tracking
- ✅ Real-time messaging
- ✅ Complaint handling with escalation

**Not a public marketplace** - Pre-approved relationships only.

---

## 🎯 MVP Scope (November 20, 2025)

### ✅ Completed
- [x] User Authentication (Login/Register)
- [x] Supplier Link System
- [x] API Service Layer
- [x] Cart Management
- [x] Order Tracking
- [x] Profile Management

### 📋 In Progress
- [ ] Chat System (real-time messaging)
- [ ] Complaint Management
- [ ] Home Screen Filtering
- [ ] Backend Integration Testing

### 🔮 Future
- [ ] Analytics Dashboards
- [ ] Payment Integration
- [ ] Logistics Tracking
- [ ] Ratings & Reviews

---

## 🚀 Quick Start

### Prerequisites
- Flutter 3.0+ ([install guide](https://flutter.dev/docs/get-started/install))
- Android Studio / Xcode
- Git

### 1. Clone & Setup
```bash
cd c:/Users/Assylkhan/Desktop/caterchain_test
flutter pub get
```

### 2. Run
```bash
flutter run
```

### 3. Test Demo Mode
- Click **"📱 Try Demo"** on Login screen
- Explore app with mock data

**For detailed setup**, see [QUICK_START.md](QUICK_START.md)

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry & navigation
├── screens/                     # UI screens (6)
├── providers/                   # State management (6)
├── models/                      # Data models (5)
├── services/
│   └── api_service.dart        # API client
├── widgets/                     # Reusable components
└── database/                    # Local storage
```

**Full structure**: [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

---

## 📱 Key Features

### 🔐 Authentication
- Email/password login
- New user registration
- JWT token management
- Automatic session persistence

### 🏢 Supplier Management
- Request supplier links
- Track pending requests
- View connected suppliers
- Manage relationships

### 🛒 Shopping
- Browse products by supplier
- Add to cart
- Manage quantities
- Order creation

### 📦 Orders
- Order history
- Status tracking
- Order details
- Reorder functionality

### 💬 Communication
- (Coming soon) Real-time chat
- Message history
- File sharing
- User status

---

## 🏗️ Architecture

### Pattern: Provider + MVC
```
Screens (UI)
    ↓
Providers (State + Business Logic)
    ↓
Services (API + Database)
    ↓
Backend API / Local Storage
```

### State Management
- **Provider**: Dependency injection & state management
- **SharedPreferences**: Local data persistence
- **ChangeNotifier**: Reactive updates

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [QUICK_START.md](QUICK_START.md) | 5-min setup guide |
| [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) | Development guide |
| [BACKEND_API_SPEC.md](BACKEND_API_SPEC.md) | API specification |
| [TESTING_GUIDE.md](TESTING_GUIDE.md) | Testing & troubleshooting |
| [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) | Architecture overview |

---

## 🔌 API Integration

### Backend Requirements
- REST API with JWT authentication
- Base endpoints for auth, products, orders, chat, complaints
- PostgreSQL database
- Docker containerization (optional)

**API Spec**: [BACKEND_API_SPEC.md](BACKEND_API_SPEC.md)

### Configuration
Update `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

---

## 🛠️ Tech Stack

### Frontend (Mobile)
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State**: Provider 6.1+
- **HTTP**: http 1.1+
- **Storage**: SharedPreferences 2.2+

### Backend (Reference)
- **Options**: Django, FastAPI, Spring Boot, Go
- **Database**: PostgreSQL
- **Auth**: JWT tokens
- **Deployment**: Docker containers

---

## 📊 Screens & Navigation

```
┌─────────────────┐
│  Login/Register │ ← Initial
└────────┬────────┘
         │
    ┌────▼─────────────────────┐
    │   Main App (Logged In)   │
    └────┬─────────────────────┘
         │
    ┌────┴──────────┬──────────┬──────────┬───────────┐
    │               │          │          │           │
    ▼               ▼          ▼          ▼           ▼
 Home        Chat        Cart       Profile    Supplier Links
 
    │                                         │
    └─────────────────┬──────────────────────┘
                      │
            ┌─────────▼─────────┐
            │ Order History     │
            └───────────────────┘
```

---

## 🧪 Testing

### Test Scenarios
1. **Demo Mode** - Quick UI/UX check
2. **Registration** - User signup flow
3. **Supplier Links** - Link management
4. **Shopping** - Cart & orders
5. **Profile** - User info & logout

**Testing guide**: [TESTING_GUIDE.md](TESTING_GUIDE.md)

---

## 🔒 Security

### Implemented
- ✅ Input validation (frontend)
- ✅ JWT token management
- ✅ Secure password input
- ✅ Error handling

### Recommended Backend
- ✅ Password hashing (bcrypt)
- ✅ HTTPS only
- ✅ Rate limiting
- ✅ CORS headers
- ✅ Input validation
- ✅ SQL injection prevention

---

## 📈 Performance

- **App Size**: ~50-80 MB (compiled)
- **Startup Time**: <3 seconds
- **List Performance**: 1000+ items with ListView.builder()
- **Memory**: ~100-150 MB during runtime

### Optimization Tips
- Use `const` constructors
- Lazy load images
- Debounce search inputs
- Unsubscribe streams properly

---

## 🐛 Troubleshooting

### Common Issues
1. **"Build failed"** → `flutter clean && flutter pub get`
2. **"Can't connect to API"** → Check Backend is running, verify URL
3. **"SharedPreferences error"** → Clear app data, reinstall
4. **"Images not loading"** → Check HTTPS, add internet permission

**Full guide**: [TESTING_GUIDE.md](TESTING_GUIDE.md)

---

## 📞 Support

- **Documentation**: Check relevant .md files
- **Flutter Issues**: https://flutter.dev/docs/testing/debugging
- **Provider Pattern**: https://pub.dev/packages/provider
- **HTTP Debugging**: Use Postman/Insomnia

---

## 📜 License

MIT License - See LICENSE file

---

## 👥 Contributors

- **Project Lead**: Marat Isteleyev
- **Development**: Your Team
- **Status**: MVP Development (Nov 2025)

---

## 🎯 Next Milestones

| Date | Goal |
|------|------|
| Nov 15 | ✅ Auth system |
| Nov 16 | 📅 Chat system |
| Nov 17 | 📅 Complaints |
| Nov 18 | 📅 Backend test |
| Nov 20 | 🚀 **MVP Launch** |

---

## 📝 Version Info

- **Current Version**: 1.0.0
- **Flutter Version**: 3.0+
- **Min Android**: API 21
- **Min iOS**: 12.0
- **Last Updated**: November 15, 2025

---

## 🚀 Getting Started

**First time?** → Start with [QUICK_START.md](QUICK_START.md)

**Need API setup?** → Check [BACKEND_API_SPEC.md](BACKEND_API_SPEC.md)

**Have questions?** → See [TESTING_GUIDE.md](TESTING_GUIDE.md)

---

**Happy coding! 🎉**
