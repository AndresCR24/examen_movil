class MantenimientoModel {
  final int? id;
  final String title;
  final String description;
  final bool completed;
  final DateTime updatedAt;
  final bool pendingSync;

  const MantenimientoModel({
    this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.updatedAt,
    required this.pendingSync,
  });

  MantenimientoModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? updatedAt,
    bool? pendingSync,
  }) {
    return MantenimientoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MantenimientoModel.fromFirestore(
    Map<String, dynamic> map, {
    required int id,
  }) {
    return MantenimientoModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      completed: map['completed'] as bool? ?? false,
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
      pendingSync: false,
    );
  }
}
