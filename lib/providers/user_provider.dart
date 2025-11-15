import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get errorMessage => _errorMessage;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Попытка загрузить сохраненного пользователя при старте приложения
  Future<void> loadSavedUser() async {
    try {
      final userData = await _databaseHelper.getUser();
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved user: $e');
    }
  }

  /// Регистрация потребителя
  Future<bool> registerConsumer({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String companyName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.registerConsumer(
        name: name,
        email: email,
        password: password,
        phone: phone,
        companyName: companyName,
      );

      final user = User.fromJson(result['user']);
      _currentUser = user;

      // Сохраняем пользователя и токен
      await _databaseHelper.saveUser(result['user']);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Вход в систему
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
      );

      final user = User.fromJson(result['user']);
      _currentUser = user;

      // Сохраняем пользователя
      await _databaseHelper.saveUser(result['user']);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Выход из системы
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.logout();
      await _databaseHelper.logoutUser();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _currentUser = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Обновить информацию о пользователе
  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Очистить сообщение об ошибке
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Мок пользователь для тестирования (когда API недоступен)
  void loginMockUser() {
    _isLoading = true;
    notifyListeners();

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
}