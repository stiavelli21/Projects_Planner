import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/project.dart';
import '../theme/app_theme.dart';
import '../widgets/color_picker.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final DatabaseHelper _db = DatabaseHelper();
  int _selectedColor = 0;
  bool _isSaving = false;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.project!.title;
      _descController.text = widget.project!.description;
      _selectedColor = widget.project!.colorIndex;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      if (_isEditing) {
        widget.project!
          ..title = _titleController.text.trim()
          ..description = _descController.text.trim()
          ..colorIndex = _selectedColor;
        await _db.updateProject(widget.project!);
      } else {
        final project = Project(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          createdAt: DateTime.now(),
          colorIndex: _selectedColor,
        );
        await _db.insertProject(project);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getProjectColor(_selectedColor);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        surfaceTintColor: Colors.transparent,
        title: Text(_isEditing ? 'Modifica progetto' : 'Nuovo progetto'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: color,
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isEditing ? 'Salva' : 'Crea',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──
              Text(
                'Titolo',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF636E72),
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Il mio nuovo progetto...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci un titolo';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),

              // ── Description ──
              Text(
                'Descrizione',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF636E72),
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Descrivi il tuo progetto...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci una descrizione';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 28),

              // ── Color ──
              Text(
                'Colore',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF636E72),
                    ),
              ),
              const SizedBox(height: 12),
              ColorPickerWidget(
                selectedIndex: _selectedColor,
                onColorSelected: (index) {
                  setState(() => _selectedColor = index);
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}
