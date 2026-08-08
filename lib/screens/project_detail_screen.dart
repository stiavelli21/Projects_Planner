import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/project.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/note_tile.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/empty_state.dart';
import 'note_editor_screen.dart';
import 'project_form_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseHelper _db = DatabaseHelper();
  List<Note> _notes = [];
  bool _isLoading = true;
  late Project _project;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadData();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final updatedProject = await _db.getProject(_project.id!);
    final notes = await _db.getNotes(_project.id!);
    if (mounted) {
      setState(() {
        if (updatedProject != null) _project = updatedProject;
        _notes = notes;
        _isLoading = false;
      });
      _fabController.forward();
    }
  }

  Future<void> _createNote() async {
    final now = DateTime.now();
    final note = Note(
      projectId: _project.id!,
      title: '',
      content: '',
      createdAt: now,
      updatedAt: now,
    );
    final id = await _db.insertNote(note);
    note.id = id;

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NoteEditorScreen(
            note: note,
            accentColor: AppTheme.getProjectColor(_project.colorIndex),
            isEditing: true,
          ),
        ),
      );
      _loadData();
    }
  }

  Future<void> _openNote(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          note: note,
          accentColor: AppTheme.getProjectColor(_project.colorIndex),
        ),
      ),
    );
    _loadData();
  }

  Future<void> _deleteNote(Note note) async {
    await _db.deleteNote(note.id!);
    _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${note.title.isNotEmpty ? note.title : "Nota"}" eliminata',
          ),
        ),
      );
    }
  }

  Future<void> _editProject() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProjectFormScreen(project: _project)),
    );
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getProjectColor(_project.colorIndex);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 15) {
          Navigator.maybePop(context);
        }
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            centerTitle: true,
            pinned: true,
            backgroundColor: color,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: Hero(
              tag: 'project_${_project.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  _project.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: _editProject,
                tooltip: 'Modifica progetto',
              ),
            ],
          ),

          // ── Project Info ──
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _project.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF636E72),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Notes Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.sticky_note_2_outlined, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(
                    'Note',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_notes.length}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Notes List ──
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_notes.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.note_add_rounded,
                title: 'Nessuna nota',
                subtitle: 'Tocca il + per aggiungere\nla tua prima nota!',
                iconColor: color.withValues(alpha: 0.5),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final note = _notes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Dismissible(
                      key: ValueKey(note.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (_) async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => const ConfirmDialog(
                            title: 'Elimina nota',
                            content: 'Sei sicuro di voler eliminare questa nota?',
                          ),
                        );
                        return confirmed ?? false;
                      },
                      onDismissed: (_) => _deleteNote(note),
                      child: NoteTile(
                        note: note,
                        onTap: () => _openNote(note),
                        accentColor: color,
                      ),
                    ),
                  );
                }, childCount: _notes.length),
              ),
            ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton(
          onPressed: _createNote,
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_rounded),
        ),
      ),
    ));
  }
}
