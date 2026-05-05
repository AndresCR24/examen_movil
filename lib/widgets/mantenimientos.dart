import 'package:flutter/material.dart';

import '../models/mantenimiento.dart';

class MantenimientoTile extends StatelessWidget {
  final MantenimientoModel mantenimiento;
  final VoidCallback onToggle;
  final ValueChanged<EstadoMantenimiento> onEstadoChanged;
  final ValueChanged<bool> onDevueltoChanged;
  final VoidCallback onDelete;

  const MantenimientoTile({
    super.key,
    required this.mantenimiento,
    required this.onToggle,
    required this.onEstadoChanged,
    required this.onDevueltoChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final estado = mantenimiento.estado;
    final isFinalizado = estado == EstadoMantenimiento.finalizado ||
        estado == EstadoMantenimiento.resuelto;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: isFinalizado ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isFinalizado
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      color: isFinalizado
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Checkbox(
                value: mantenimiento.completed,
                onChanged: (_) => onToggle(),
                activeColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    mantenimiento.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration: isFinalizado
                              ? TextDecoration.lineThrough
                              : null,
                          color: isFinalizado
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (mantenimiento.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      mantenimiento.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Fila de chips de estado
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _EstadoChip(estado: estado),
                      _DevueltoChip(devuelto: mantenimiento.devuelto),
                      if (mantenimiento.pendingSync)
                        _SyncChip(colorScheme: colorScheme),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            // Menú de acciones
            _ActionsMenu(
              mantenimiento: mantenimiento,
              onEstadoChanged: onEstadoChanged,
              onDevueltoChanged: onDevueltoChanged,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Chip de estado ────────────────────────────────────────────────────────────

class _EstadoChip extends StatelessWidget {
  final EstadoMantenimiento estado;

  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (estado) {
      EstadoMantenimiento.pendiente => (Colors.orange, Icons.hourglass_empty),
      EstadoMantenimiento.atendido => (Colors.blue, Icons.engineering),
      EstadoMantenimiento.resuelto => (Colors.green, Icons.check_circle),
      EstadoMantenimiento.finalizado => (Colors.grey, Icons.archive),
    };

    return _StatusBadge(
      icon: icon,
      label: estado.label,
      color: color,
    );
  }
}

// ─── Chip de devuelto ──────────────────────────────────────────────────────────

class _DevueltoChip extends StatelessWidget {
  final bool devuelto;

  const _DevueltoChip({required this.devuelto});

  @override
  Widget build(BuildContext context) {
    return _StatusBadge(
      icon: devuelto ? Icons.assignment_return : Icons.assignment_late,
      label: devuelto ? 'Devuelto' : 'No devuelto',
      color: devuelto ? Colors.teal : Colors.deepOrange,
    );
  }
}

// ─── Chip de sincronización ────────────────────────────────────────────────────

class _SyncChip extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SyncChip({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return _StatusBadge(
      icon: Icons.sync_problem,
      label: 'Sin sincronizar',
      color: colorScheme.error,
    );
  }
}

// ─── Badge genérico ────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Menú de acciones ──────────────────────────────────────────────────────────

class _ActionsMenu extends StatelessWidget {
  final MantenimientoModel mantenimiento;
  final ValueChanged<EstadoMantenimiento> onEstadoChanged;
  final ValueChanged<bool> onDevueltoChanged;
  final VoidCallback onDelete;

  const _ActionsMenu({
    required this.mantenimiento,
    required this.onEstadoChanged,
    required this.onDevueltoChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
      tooltip: 'Acciones',
      itemBuilder: (context) => [
        const PopupMenuItem(
          enabled: false,
          child: Text(
            'Cambiar estado',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        ...EstadoMantenimiento.values.map(
          (e) => PopupMenuItem<String>(
            value: 'estado_${e.name}',
            child: Row(
              children: [
                Icon(
                  _iconForEstado(e),
                  size: 16,
                  color: mantenimiento.estado == e
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(e.label),
                if (mantenimiento.estado == e) ...[
                  const Spacer(),
                  Icon(Icons.check, size: 14, color: colorScheme.primary),
                ],
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: mantenimiento.devuelto ? 'devuelto_false' : 'devuelto_true',
          child: Row(
            children: [
              Icon(
                mantenimiento.devuelto
                    ? Icons.assignment_late
                    : Icons.assignment_return,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(mantenimiento.devuelto
                  ? 'Marcar como No devuelto'
                  : 'Marcar como Devuelto'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 16, color: colorScheme.error),
              const SizedBox(width: 8),
              Text('Eliminar', style: TextStyle(color: colorScheme.error)),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        if (value.startsWith('estado_')) {
          final nombre = value.replaceFirst('estado_', '');
          final nuevoEstado = EstadoMantenimiento.fromString(nombre);
          onEstadoChanged(nuevoEstado);
        } else if (value.startsWith('devuelto_')) {
          final devuelto = value == 'devuelto_true';
          onDevueltoChanged(devuelto);
        } else if (value == 'delete') {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Eliminar registro'),
              content: Text(
                '¿Confirmas que deseas eliminar "${mantenimiento.title}"?\nEsta acción no se puede deshacer.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                  ),
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          );
          if (confirmed == true) onDelete();
        }
      },
    );
  }

  IconData _iconForEstado(EstadoMantenimiento e) {
    return switch (e) {
      EstadoMantenimiento.pendiente => Icons.hourglass_empty,
      EstadoMantenimiento.atendido => Icons.engineering,
      EstadoMantenimiento.resuelto => Icons.check_circle,
      EstadoMantenimiento.finalizado => Icons.archive,
    };
  }
}