import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';
import '../widgets/empty_state.dart';
import 'project_form_screen.dart';
import 'project_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final DatabaseHelper _db = DatabaseHelper();
  List<Project> _projects = [];
  bool _isLoading = true;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadProjects();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    final projects = await _db.getProjects();
    if (mounted) {
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
      _fabController.forward();
    }
  }

  Future<void> _createProject() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const ProjectFormScreen(),
      ),
    );
    if (result == true) {
      _loadProjects();
    }
  }

  Future<void> _editProject(Project project) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectFormScreen(project: project),
      ),
    );
    if (result == true) {
      _loadProjects();
    }
  }


  Future<void> _openProject(Project project) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(project: project),
      ),
    );
    _loadProjects(); // Refresh note counts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            backgroundColor: const Color(0xFFFAFAFA),
            surfaceTintColor: Colors.transparent,
            floating: true,
            snap: true,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFFB347)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Projects'),
              ],
            ),
          ),

          // ── Content ──
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_projects.isEmpty)
            const SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.lightbulb_outline_rounded,
                title: 'Nessun progetto ancora',
                subtitle:
                    'Tocca il + per creare il tuo primo progetto\ne iniziare a prendere appunti!',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final project = _projects[index];
                    return Dismissible(
                      key: ValueKey(project.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (_) async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Elimina progetto'),
                            content: Text(
                              'Vuoi eliminare "${project.title}" e tutte le sue note?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Annulla'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Elimina'),
                              ),
                            ],
                          ),
                        );
                        return confirmed ?? false;
                      },
                      onDismissed: (_) async {
                        await _db.deleteProject(project.id!);
                        _loadProjects();
                      },
                      child: ProjectCard(
                        project: project,
                        onTap: () => _openProject(project),
                        onLongPress: () => _editProject(project),
                      ),
                    );
                  },
                  childCount: _projects.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: _createProject,
          backgroundColor: const Color(0xFFFF6B6B),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Nuovo progetto',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
