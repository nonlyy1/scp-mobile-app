import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class Complaint {
  final int id;
  final int orderId;
  final int consumerId;
  final int supplierId;
  final String description;
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final String? resolution;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? assignedTo; // sales, manager, owner
  final String? priority; // low, medium, high, critical

  Complaint({
    required this.id,
    required this.orderId,
    required this.consumerId,
    required this.supplierId,
    required this.description,
    required this.status,
    this.resolution,
    required this.createdAt,
    this.resolvedAt,
    this.assignedTo,
    this.priority,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      orderId: json['order_id'],
      consumerId: json['consumer_id'],
      supplierId: json['supplier_id'],
      description: json['description'] ?? '',
      status: json['status'] ?? 'open',
      resolution: json['resolution'],
      createdAt: DateTime.parse(json['created_at']),
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.parse(json['resolved_at']) 
          : null,
      assignedTo: json['assigned_to'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'consumer_id': consumerId,
      'supplier_id': supplierId,
      'description': description,
      'status': status,
      'resolution': resolution,
      'created_at': createdAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'assigned_to': assignedTo,
      'priority': priority,
    };
  }
}

class ComplaintProvider with ChangeNotifier {
  List<Complaint> _complaints = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Complaint> get complaints => List.unmodifiable(_complaints);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Фильтры
  List<Complaint> get openComplaints =>
      _complaints.where((c) => c.status == 'open' || c.status == 'in_progress').toList();

  List<Complaint> get resolvedComplaints =>
      _complaints.where((c) => c.status == 'resolved' || c.status == 'closed').toList();

  // Загрузить все жалобы
  Future<void> loadComplaints() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final complaintsData = await ApiService.getComplaints();
      _complaints = complaintsData.map((json) => Complaint.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Создать жалобу
  Future<bool> createComplaint({
    required int orderId,
    required String description,
    String? priority,
  }) async {
    try {
      final result = await ApiService.createComplaint(
        orderId: orderId,
        description: description,
      );

      final newComplaint = Complaint(
        id: result['id'] ?? DateTime.now().millisecond,
        orderId: orderId,
        consumerId: result['consumer_id'] ?? 1,
        supplierId: result['supplier_id'] ?? 1,
        description: description,
        status: 'open',
        createdAt: DateTime.now(),
        priority: priority,
      );

      _complaints.insert(0, newComplaint);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Получить жалобу по ID
  Complaint? getComplaintById(int id) {
    try {
      return _complaints.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Получить жалобы по заказу
  List<Complaint> getComplaintsByOrder(int orderId) {
    return _complaints.where((c) => c.orderId == orderId).toList();
  }

  // Очистить ошибку
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Mock данные для тестирования
  void loadMockComplaints() {
    _complaints = [
      Complaint(
        id: 1,
        orderId: 100,
        consumerId: 1,
        supplierId: 1,
        description: 'Items arrived damaged. Some tomatoes were rotten.',
        status: 'in_progress',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        assignedTo: 'manager',
        priority: 'high',
      ),
      Complaint(
        id: 2,
        orderId: 101,
        consumerId: 1,
        supplierId: 2,
        description: 'Delivery delayed by 3 hours.',
        status: 'resolved',
        resolution: 'Applied 10% discount to next order',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        resolvedAt: DateTime.now().subtract(const Duration(days: 4)),
        priority: 'medium',
      ),
      Complaint(
        id: 3,
        orderId: 102,
        consumerId: 1,
        supplierId: 1,
        description: 'Wrong quantity delivered - received 5kg instead of 10kg',
        status: 'open',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        priority: 'critical',
      ),
    ];
    notifyListeners();
  }
}
