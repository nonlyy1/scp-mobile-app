import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Мок пользователь для тестирования
  void loginMockUser() {
    _isLoading = true;
    notifyListeners();

    // Имитация загрузки
    Future.delayed(const Duration(seconds: 1), () {
      _currentUser = User(
        id: 1,
        name: 'Assylkhan Kerey',
        email: 'assylkhan.kerey@nu.edu.kz',
        phone: '+77771234567',
        role: 'consumer',
        companyId: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
    });
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}