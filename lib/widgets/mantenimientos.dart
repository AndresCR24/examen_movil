import 'package:flutter/material.dart';

import '../models/mantenimiento.dart';

class MantenimientoTile extends StatelessWidget {
  final MantenimientoModel mantenimiento;
  final VoidCallback onToggle;

  const MantenimientoTile({
    super.key,
    required this.mantenimiento,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = mantenimiento.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: isCompleted ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCompleted
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      color: isCompleted
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Checkbox(
                  value: isCompleted,
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
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isCompleted
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
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.pending_outlined,
                          size: 13,
                          color: isCompleted
                              ? Colors.green.shade600
                              : colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCompleted ? 'Completada' : 'Pendiente',
                          style: TextStyle(
                            fontSize: 11,
                            color: isCompleted
                                ? Colors.green.shade600
                                : colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (mantenimiento.pendingSync)
                          _SyncChip(colorScheme: colorScheme),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncChip extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SyncChip({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sync_problem,
            size: 10,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 2),
          Text(
            'Sin sincronizar',
            style: TextStyle(
              fontSize: 9,
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}