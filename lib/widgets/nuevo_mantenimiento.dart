import 'package:flutter/material.dart';

class MantenimientoFormResult {
  final String title;
  final String description;

  const MantenimientoFormResult({
    required this.title,
    required this.description,
  });
}

class MantenimientoFormDialog extends StatefulWidget {
  const MantenimientoFormDialog({super.key});

  @override
  State<MantenimientoFormDialog> createState() =>
      _MantenimientoFormDialogState();
}

class _MantenimientoFormDialogState extends State<MantenimientoFormDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      setState(() => _titleError = 'El título no puede estar vacío.');
      return;
    }

    Navigator.of(context).pop(
      MantenimientoFormResult(title: title, description: description),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      title: Row(
        children: [
          Icon(Icons.add_task, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Nueva tarea'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registra una tarea de mantenimiento en el campus UDEM',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Título *',
              hintText: 'Ej: Cambiar bombillas en aula 301',
              errorText: _titleError,
              prefixIcon: const Icon(Icons.construction),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (_) {
              if (_titleError != null) setState(() => _titleError = null);
            },
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Descripción',
              hintText: 'Detalla la ubicación o requerimientos',
              prefixIcon: const Icon(Icons.notes),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save),
          label: const Text('Guardar'),
        ),
      ],
    );
  }
}