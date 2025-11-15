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
