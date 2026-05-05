import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Importa tu archivo donde está definido MantenimientoModel
import 'package:mantenimiento_campus/models/mantenimiento.dart';

part 'database.g.dart';

@DataClassName('Mantenimiento')
class Mantenimientos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [Mantenimientos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'mantenimiento_app_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  // Mapeador de la tabla (Drift) al Modelo (MantenimientoModel)
  MantenimientoModel _mapToModel(Mantenimiento row) {
    return MantenimientoModel(
      id: row.id,
      title: row.title,
      description: row.description,
      completed: row.completed,
      updatedAt: row.updatedAt,
      pendingSync: row.pendingSync,
    );
  }

  Stream<List<MantenimientoModel>> watchMantenimientos() {
    final query = select(mantenimientos)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);

    return query.watch().map((rows) => rows.map(_mapToModel).toList());
  }

  Future<List<MantenimientoModel>> getAllMantenimientos() async {
    final rows = await select(mantenimientos).get();
    return rows.map(_mapToModel).toList();
  }

  Future<MantenimientoModel> insertMantenimiento(MantenimientoModel model) async {
    final insertedId = await into(mantenimientos).insert(
      MantenimientosCompanion.insert(
        title: model.title,
        description: model.description,
        completed: Value(model.completed),
        updatedAt: model.updatedAt,
        pendingSync: Value(model.pendingSync),
      ),
    );

    return model.copyWith(id: insertedId);
  }

  Future<void> updateMantenimiento(MantenimientoModel model) async {
    if (model.id == null) return;

    await update(mantenimientos).replace(
      Mantenimiento(
        id: model.id!,
        title: model.title,
        description: model.description,
        completed: model.completed,
        updatedAt: model.updatedAt,
        pendingSync: model.pendingSync,
      ),
    );
  }

  Future<void> toggleCompleted({
    required int id,
    required bool completed,
  }) async {
    await (update(mantenimientos)..where((t) => t.id.equals(id))).write(
      MantenimientosCompanion(
        completed: Value(completed),
        updatedAt: Value(DateTime.now()),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<List<MantenimientoModel>> getPendingMantenimientos() async {
    final rows = await (select(mantenimientos)..where((t) => t.pendingSync.equals(true))).get();
    return rows.map(_mapToModel).toList();
  }

  Future<void> markAsSynced(int id) async {
    await (update(mantenimientos)..where((t) => t.id.equals(id))).write(
      const MantenimientosCompanion(
        pendingSync: Value(false),
      ),
    );
  }

  Future<void> upsertFromRemote(MantenimientoModel model) async {
    if (model.id == null) return;

    await into(mantenimientos).insertOnConflictUpdate(
      MantenimientosCompanion(
        id: Value(model.id!),
        title: Value(model.title),
        description: Value(model.description),
        completed: Value(model.completed),
        updatedAt: Value(model.updatedAt),
        pendingSync: const Value(false),
      ),
    );
  }
}