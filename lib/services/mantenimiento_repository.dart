import 'package:flutter/foundation.dart';

import '../data/database.dart';
import '../models/mantenimiento.dart';
import 'mantenimiento_service.dart';

class MantenimientoRepository {
  final AppDatabase localDb;
  final MantenimientoRemoteService remoteService;

  MantenimientoRepository({
    required this.localDb,
    required this.remoteService,
  });

  Stream<List<MantenimientoModel>> watchTasks() {
    return localDb.watchMantenimientos();
  }

  Future<void> loadInitialData() async {
    debugPrint('[MantenimientoRepository] Cargando datos iniciales');
    await refreshFromRemote();
    await syncPendingTasks();
  }

  Future<void> addTask({
    required String title,
    required String description,
    EstadoMantenimiento estado = EstadoMantenimiento.pendiente,
  }) async {
    final task = MantenimientoModel(
      title: title,
      description: description,
      completed: false,
      estado: estado,
      devuelto: false,
      updatedAt: DateTime.now(),
      pendingSync: true,
    );

    final inserted = await localDb.insertMantenimiento(task);
    debugPrint('[MantenimientoRepository] Tarea creada localmente: ${inserted.id}');

    try {
      await remoteService.upsertTask(inserted);
      if (inserted.id != null) {
        await localDb.markAsSynced(inserted.id!);
        debugPrint('[MantenimientoRepository] Sincronizada: ${inserted.id}');
      }
    } catch (e) {
      debugPrint('[MantenimientoRepository] Quedó pendiente de sync: $e');
      rethrow;
    }
  }

  Future<void> toggleTask(MantenimientoModel task) async {
    if (task.id == null) return;

    await localDb.toggleCompleted(
      id: task.id!,
      completed: !task.completed,
    );

    try {
      final updated = task.copyWith(
        completed: !task.completed,
        updatedAt: DateTime.now(),
        pendingSync: true,
      );
      await remoteService.upsertTask(updated);
      await localDb.markAsSynced(task.id!);
      debugPrint('[MantenimientoRepository] Toggle sincronizado: ${task.id}');
    } catch (e) {
      debugPrint('[MantenimientoRepository] Toggle pendiente de sync: $e');
      rethrow;
    }
  }

  Future<void> updateEstado({
    required MantenimientoModel task,
    required EstadoMantenimiento estado,
  }) async {
    if (task.id == null) return;

    await localDb.updateEstado(id: task.id!, estado: estado);

    try {
      final updated = task.copyWith(
        estado: estado,
        updatedAt: DateTime.now(),
        pendingSync: true,
      );
      await remoteService.upsertTask(updated);
      await localDb.markAsSynced(task.id!);
      debugPrint('[MantenimientoRepository] Estado actualizado: ${task.id} → ${estado.name}');
    } catch (e) {
      debugPrint('[MantenimientoRepository] updateEstado pendiente de sync: $e');
      rethrow;
    }
  }

  Future<void> updateDevuelto({
    required MantenimientoModel task,
    required bool devuelto,
  }) async {
    if (task.id == null) return;

    await localDb.updateDevuelto(id: task.id!, devuelto: devuelto);

    try {
      final updated = task.copyWith(
        devuelto: devuelto,
        updatedAt: DateTime.now(),
        pendingSync: true,
      );
      await remoteService.upsertTask(updated);
      await localDb.markAsSynced(task.id!);
      debugPrint('[MantenimientoRepository] Devuelto actualizado: ${task.id} → $devuelto');
    } catch (e) {
      debugPrint('[MantenimientoRepository] updateDevuelto pendiente de sync: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(MantenimientoModel task) async {
    if (task.id == null) return;

    await localDb.deleteMantenimiento(task.id!);
    debugPrint('[MantenimientoRepository] Eliminado localmente: ${task.id}');

    try {
      await remoteService.deleteTask(task.id!);
      debugPrint('[MantenimientoRepository] Eliminado en Firebase: ${task.id}');
    } catch (e) {
      debugPrint('[MantenimientoRepository] Error al eliminar en Firebase: $e');
      rethrow;
    }
  }

  Future<void> refreshFromRemote() async {
    try {
      final remoteTasks = await remoteService.fetchTasks();
      for (final task in remoteTasks) {
        await localDb.upsertFromRemote(task);
      }
      debugPrint(
        '[MantenimientoRepository] Refresco remoto: ${remoteTasks.length} tareas',
      );
    } catch (e) {
      debugPrint('[MantenimientoRepository] Error refrescando desde Firebase: $e');
    }
  }

  Future<void> syncPendingTasks() async {
    final pending = await localDb.getPendingMantenimientos();
    debugPrint('[MantenimientoRepository] Tareas pendientes: ${pending.length}');

    for (final task in pending) {
      try {
        await remoteService.upsertTask(task);
        if (task.id != null) {
          await localDb.markAsSynced(task.id!);
          debugPrint('[MantenimientoRepository] Pendiente sincronizada: ${task.id}');
        }
      } catch (e) {
        debugPrint('[MantenimientoRepository] Error en pendiente ${task.id}: $e');
      }
    }
  }
}