import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../data/database_helper.dart';
import '../models/note.dart';

List<TextSpan> _parseMarkdown(String text, TextStyle? style, {bool keepMarkers = false}) {
  final List<TextSpan> children = [];
  final boldPattern = RegExp(r'\*\*(.*?)\*\*');

  text.splitMapJoin(
    boldPattern,
    onMatch: (Match match) {
      children.add(TextSpan(
        text: keepMarkers ? match[0] : match[1],
        style: style?.copyWith(fontWeight: FontWeight.bold),
      ));
      return '';
    },
    onNonMatch: (String nonMatch) {
      final italicPattern = RegExp(r'\*(.*?)\*');
      nonMatch.splitMapJoin(
        italicPattern,
        onMatch: (Match match) {
          children.add(TextSpan(
            text: keepMarkers ? match[0] : match[1],
            style: style?.copyWith(fontStyle: FontStyle.italic),
          ));
          return '';
        },
        onNonMatch: (String text2) {
          children.add(TextSpan(text: text2, style: style));
          return '';
        },
      );
      return '';
    },
  );

  return children;
}

class MarkdownTextEditingController extends TextEditingController {
  MarkdownTextEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(
      style: style,
      children: _parseMarkdown(text, style, keepMarkers: true),
    );
  }
}

class NoteEditorScreen extends StatefulWidget {
  final Note note;
  final Color accentColor;
  final bool isEditing;

  const NoteEditorScreen({
    super.key,
    required this.note,
    required this.accentColor,
    this.isEditing = false,
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
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = MarkdownTextEditingController(text: widget.note.content);

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

  Future<void> _handleSaveAction() async {
    if (_hasChanges) {
      await _save();
    }
    setState(() {
      _isEditing = false;
    });
  }

  void _showMarkdownHelp() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: MediaQuery.of(context).padding.bottom + 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guida al Markdown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
              ),
              const SizedBox(height: 20),
              _buildHelpRow('**Testo**', 'Grassetto'),
              _buildHelpRow('*Testo*', 'Corsivo'),
              _buildHelpRow('# Testo', 'Titolo 1'),
              _buildHelpRow('## Testo', 'Titolo 2'),
              _buildHelpRow('- Testo', 'Lista puntata'),
              _buildHelpRow('> Testo', 'Citazione'),
              _buildHelpRow('[Nome](url)', 'Link'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Chiudi', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpRow(String syntax, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                syntax,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ],
      ),
    );
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
            if (_isEditing)
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
                        onPressed: _handleSaveAction,
                        style: IconButton.styleFrom(
                          backgroundColor: widget.accentColor,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.check_rounded, size: 20),
                        tooltip: 'Chiudi modifica',
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
              if (_isEditing)
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
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: Text(
                    _titleController.text.isEmpty
                        ? 'Senza titolo'
                        : _titleController.text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3436),
                        ),
                  ),
                ),
              Divider(
                color: widget.accentColor.withValues(alpha: 0.2),
                height: 24,
              ),
              // ── Content ──
              if (_isEditing)
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
                )
              else
                MarkdownBody(
                  data: _contentController.text.isEmpty
                      ? '*Nessun contenuto*'
                      : _contentController.text,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF2D3436),
                          height: 1.8,
                        ),
                    listBullet: TextStyle(
                      color: widget.accentColor,
                      fontSize: 16,
                    ),
                    h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3436),
                        ),
                    h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3436),
                        ),
                    blockquote: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                    blockquoteDecoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: widget.accentColor, width: 4),
                      ),
                      color: Colors.grey.shade100,
                    ),
                    blockquotePadding: const EdgeInsets.all(12),
                    a: TextStyle(color: widget.accentColor, decoration: TextDecoration.underline),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButtonLocation: _isEditing 
            ? FloatingActionButtonLocation.startFloat 
            : FloatingActionButtonLocation.endFloat,
        floatingActionButton: _isEditing
            ? GestureDetector(
                onTap: _showMarkdownHelp,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: widget.accentColor,
                    size: 20,
                  ),
                ),
              )
            : FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                backgroundColor: widget.accentColor,
                foregroundColor: Colors.white,
                child: const Icon(Icons.edit_rounded),
              ),
      ),
    );
  }
}
