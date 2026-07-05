import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/note.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;
  final Color accentColor;

  const NoteEditorScreen({
    super.key,
    required this.note,
    required this.accentColor,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);

    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onChanged);
    _contentController.removeListener(_onChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // If note is completely empty, delete it
    if (title.isEmpty && content.isEmpty) {
      await _db.deleteNote(widget.note.id!);
    } else {
      widget.note
        ..title = title
        ..content = content
        ..updatedAt = DateTime.now();
      await _db.updateNote(widget.note);
    }

    setState(() {
      _isSaving = false;
      _hasChanges = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop && _hasChanges) {
          await _save();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (_hasChanges) {
                await _save();
              }
              if (context.mounted) Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Nota'),
            ],
          ),
          actions: [
            if (_hasChanges)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _isSaving
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        onPressed: _save,
                        icon: Icon(
                          Icons.check_rounded,
                          color: widget.accentColor,
                        ),
                        tooltip: 'Salva',
                      ),
              ),
            if (!_hasChanges)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.cloud_done_rounded,
                  color: Colors.grey.shade300,
                  size: 20,
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D3436),
                    ),
                decoration: InputDecoration(
                  hintText: 'Titolo della nota...',
                  hintStyle:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFDFE6E9),
                          ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Divider(
                color: widget.accentColor.withValues(alpha: 0.2),
                height: 24,
              ),
              // ── Content ──
              TextField(
                controller: _contentController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                minLines: 20,
                keyboardType: TextInputType.multiline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF2D3436),
                      height: 1.8,
                    ),
                decoration: InputDecoration(
                  hintText: 'Inizia a scrivere...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFDFE6E9),
                      ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
