import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/mantenimiento.dart';

class MantenimientoRemoteService {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('mantenimientos');

  Future<void> upsertTask(MantenimientoModel task) async {
    if (task.id == null) {
      debugPrint('[MantenimientoRemoteService] Sin id local, no se sincroniza');
      return;
    }

    try {
      await _ref.doc(task.id.toString()).set(task.toFirestore());
      debugPrint('[MantenimientoRemoteService] Guardado en Firebase: ${task.id}');
    } on FirebaseException catch (e, st) {
      debugPrint('[MantenimientoRemoteService] FirebaseException: ${e.message}');
      Error.throwWithStackTrace(e, st);
    } catch (e, st) {
      debugPrint('[MantenimientoRemoteService] Error inesperado: $e');
      Error.throwWithStackTrace(e, st);
    }
  }

  Future<List<MantenimientoModel>> fetchTasks() async {
    try {
      final snapshot = await _ref.get();
      debugPrint(
        '[MantenimientoRemoteService] Tareas obtenidas: ${snapshot.docs.length}',
      );
      return snapshot.docs.map((doc) {
        return MantenimientoModel.fromFirestore(
          doc.data(),
          id: int.tryParse(doc.id) ?? 0,
        );
      }).toList();
    } on FirebaseException catch (e, st) {
      debugPrint('[MantenimientoRemoteService] FirebaseException fetch: ${e.code} - ${e.message}');
      Error.throwWithStackTrace(e, st);
    } catch (e, st) {
      debugPrint('[MantenimientoRemoteService] Error inesperado fetch: $e');
      Error.throwWithStackTrace(e, st);
    }
    return [];
  }
}
