enum EstadoMantenimiento {
  pendiente,
  atendido,
  resuelto,
  finalizado;

  String get label {
    switch (this) {
      case EstadoMantenimiento.pendiente:
        return 'Pendiente';
      case EstadoMantenimiento.atendido:
        return 'Atendido';
      case EstadoMantenimiento.resuelto:
        return 'Resuelto';
      case EstadoMantenimiento.finalizado:
        return 'Finalizado';
    }
  }

  static EstadoMantenimiento fromString(String value) {
    return EstadoMantenimiento.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EstadoMantenimiento.pendiente,
    );
  }
}

class MantenimientoModel {
  final int? id;
  final String title;
  final String description;
  final bool completed;
  final EstadoMantenimiento estado;
  final bool devuelto;
  final DateTime updatedAt;
  final bool pendingSync;

  const MantenimientoModel({
    this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.estado,
    required this.devuelto,
    required this.updatedAt,
    required this.pendingSync,
  });

  MantenimientoModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    EstadoMantenimiento? estado,
    bool? devuelto,
    DateTime? updatedAt,
    bool? pendingSync,
  }) {
    return MantenimientoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      estado: estado ?? this.estado,
      devuelto: devuelto ?? this.devuelto,
      updatedAt: updatedAt ?? this.updatedAt,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'estado': estado.name,
      'devuelto': devuelto,
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
      estado: EstadoMantenimiento.fromString(map['estado'] as String? ?? ''),
      devuelto: map['devuelto'] as bool? ?? false,
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
      pendingSync: false,
    );
  }
}
