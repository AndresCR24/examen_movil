import 'package:flutter/material.dart';

import '../models/mantenimiento.dart';
import '../services/mantenimiento_repository.dart';
import '../widgets/mantenimientos.dart';
import '../widgets/nuevo_mantenimiento.dart';

class HomePage extends StatefulWidget {
  final MantenimientoRepository repository;

  const HomePage({super.key, required this.repository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  bool _syncing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await widget.repository.loadInitialData();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addTask() async {
    final result = await showDialog<MantenimientoFormResult>(
      context: context,
      builder: (_) => const MantenimientoFormDialog(),
    );
    if (result != null && mounted) {
      try {
        await widget.repository.addTask(
          title: result.title,
          description: result.description,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado y sincronizado')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al sincronizar: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 6),
            ),
          );
        }
      }
    }
  }

  Future<void> _updateEstado(
    MantenimientoModel task,
    EstadoMantenimiento estado,
  ) async {
    try {
      await widget.repository.updateEstado(task: task, estado: estado);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estado actualizado: ${estado.label}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar estado: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  Future<void> _updateDevuelto(MantenimientoModel task, bool devuelto) async {
    try {
      await widget.repository.updateDevuelto(task: task, devuelto: devuelto);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(devuelto ? 'Marcado como devuelto' : 'Marcado como no devuelto'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  Future<void> _deleteTask(MantenimientoModel task) async {
    try {
      await widget.repository.deleteTask(task);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro eliminado'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  Future<void> _syncAll() async {
    setState(() => _syncing = true);
    try {
      await widget.repository.syncPendingTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sincronización completada'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al sincronizar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campus UDEM',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            Text(
              'Mantenimiento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          if (_syncing)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: _syncAll,
              tooltip: 'Sincronizar pendientes',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _buildContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add_task),
        label: const Text('Nueva tarea'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildError() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los datos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _init();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<List<MantenimientoModel>>(
      stream: widget.repository.watchTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data ?? [];
        final sinSync = tasks.where((t) => t.pendingSync).length;
        final resueltos = tasks
            .where((t) =>
                t.estado == EstadoMantenimiento.resuelto ||
                t.estado == EstadoMantenimiento.finalizado)
            .length;
        final pendientes = tasks
            .where((t) => t.estado == EstadoMantenimiento.pendiente)
            .length;

        return Column(
          children: [
            _buildSummaryBar(
              total: tasks.length,
              pendientes: pendientes,
              resueltos: resueltos,
              sinSync: sinSync,
            ),
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return MantenimientoTile(
                          mantenimiento: task,
                          onToggle: () =>
                              widget.repository.toggleTask(task),
                          onEstadoChanged: (estado) =>
                              _updateEstado(task, estado),
                          onDevueltoChanged: (devuelto) =>
                              _updateDevuelto(task, devuelto),
                          onDelete: () => _deleteTask(task),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryBar({
    required int total,
    required int pendientes,
    required int resueltos,
    required int sinSync,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          _StatChip(label: 'Total', value: total, color: colorScheme.onPrimary),
          const SizedBox(width: 8),
          _StatChip(
            label: 'Pendientes',
            value: pendientes,
            color: Colors.orangeAccent.shade100,
          ),
          const SizedBox(width: 8),
          _StatChip(
            label: 'Resueltos',
            value: resueltos,
            color: Colors.greenAccent.shade100,
          ),
          if (sinSync > 0) ...[
            const SizedBox(width: 8),
            _StatChip(
              label: 'Sin sync',
              value: sinSync,
              color: Colors.redAccent.shade100,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Sin tareas de mantenimiento',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón para registrar\nuna nueva tarea en el campus.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.85),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
