import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api'; // Измени на реальный URL
  static String? _authToken;

  static String? get authToken => _authToken;

  // Установка токена
  static void setAuthToken(String token) {
    _authToken = token;
  }

  // Очистка токена при logout
  static void clearAuthToken() {
    _authToken = null;
  }

  // Headers с авторизацией
  static Map<String, String> _getHeaders({bool requireAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requireAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // ============ AUTH ENDPOINTS ============

  /// Регистрация нового потребителя (consumer)
  static Future<Map<String, dynamic>> registerConsumer({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String companyName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/consumer'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'company_name': companyName,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        return data;
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  /// Вход в систему
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        return data;
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Получение текущего пользователя
  static Future<User> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Failed to get user');
      }
    } catch (e) {
      throw Exception('Get user error: $e');
    }
  }

  /// Logout
  static Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _getHeaders(requireAuth: true),
      );
    } catch (e) {
      print('Logout error: $e');
    } finally {
      clearAuthToken();
    }
  }

  // ============ SUPPLIER LINK ENDPOINTS ============

  /// Получить список связей с поставщиками
  static Future<List<Map<String, dynamic>>> getSupplierLinks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/supplier-links'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['links'] ?? []);
      } else {
        throw Exception('Failed to get supplier links');
      }
    } catch (e) {
      throw Exception('Get links error: $e');
    }
  }

  /// Отправить запрос на связь с поставщиком
  static Future<Map<String, dynamic>> requestSupplierLink({
    required int supplierId,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/supplier-links/request'),
        headers: _getHeaders(requireAuth: true),
        body: jsonEncode({
          'supplier_id': supplierId,
          'message': message,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Request failed');
      }
    } catch (e) {
      throw Exception('Request link error: $e');
    }
  }

  // ============ PRODUCT ENDPOINTS ============

  /// Получить все доступные продукты
  static Future<List<Map<String, dynamic>>> getProducts({int? supplierId}) async {
    try {
      String url = '$baseUrl/products';
      if (supplierId != null) {
        url += '?supplier_id=$supplierId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['products'] ?? []);
      } else {
        throw Exception('Failed to get products');
      }
    } catch (e) {
      throw Exception('Get products error: $e');
    }
  }

  // ============ ORDER ENDPOINTS ============

  /// Создать заказ
  static Future<Map<String, dynamic>> createOrder({
    required int supplierId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: _getHeaders(requireAuth: true),
        body: jsonEncode({
          'supplier_id': supplierId,
          'items': items,
          'notes': notes,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Order creation failed');
      }
    } catch (e) {
      throw Exception('Create order error: $e');
    }
  }

  /// Получить все заказы
  static Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['orders'] ?? []);
      } else {
        throw Exception('Failed to get orders');
      }
    } catch (e) {
      throw Exception('Get orders error: $e');
    }
  }

  // ============ CHAT ENDPOINTS ============

  /// Получить чаты (по поставщику)
  static Future<List<Map<String, dynamic>>> getChats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['chats'] ?? []);
      } else {
        throw Exception('Failed to get chats');
      }
    } catch (e) {
      throw Exception('Get chats error: $e');
    }
  }

  /// Отправить сообщение
  static Future<Map<String, dynamic>> sendMessage({
    required int chatId,
    required String message,
    String? fileUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/$chatId/messages'),
        headers: _getHeaders(requireAuth: true),
        body: jsonEncode({
          'message': message,
          'file_url': fileUrl,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Send message error: $e');
    }
  }

  // ============ COMPLAINT ENDPOINTS ============

  /// Создать жалобу
  static Future<Map<String, dynamic>> createComplaint({
    required int orderId,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/complaints'),
        headers: _getHeaders(requireAuth: true),
        body: jsonEncode({
          'order_id': orderId,
          'description': description,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Complaint creation failed');
      }
    } catch (e) {
      throw Exception('Create complaint error: $e');
    }
  }

  /// Получить жалобы
  static Future<List<Map<String, dynamic>>> getComplaints() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/complaints'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['complaints'] ?? []);
      } else {
        throw Exception('Failed to get complaints');
      }
    } catch (e) {
      throw Exception('Get complaints error: $e');
    }
  }
}
