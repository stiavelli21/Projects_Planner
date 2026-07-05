import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/project.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'projects_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        colorIndex INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectId INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');
  }

  // ── Projects ──────────────────────────────────────────────

  Future<List<Project>> getProjects() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.*, COUNT(n.id) as noteCount, MAX(n.createdAt) as latestNoteDate
      FROM projects p
      LEFT JOIN notes n ON n.projectId = p.id
      GROUP BY p.id
      ORDER BY COALESCE(latestNoteDate, p.createdAt) DESC
    ''');
    return result.map((map) => Project.fromMap(map)).toList();
  }

  Future<Project?> getProject(int id) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.*, COUNT(n.id) as noteCount
      FROM projects p
      LEFT JOIN notes n ON n.projectId = p.id
      WHERE p.id = ?
      GROUP BY p.id
    ''', [id]);
    if (result.isEmpty) return null;
    return Project.fromMap(result.first);
  }

  Future<int> insertProject(Project project) async {
    final db = await database;
    return await db.insert('projects', project.toMap());
  }

  Future<int> updateProject(Project project) async {
    final db = await database;
    return await db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  Future<int> deleteProject(int id) async {
    final db = await database;
    // Delete associated notes first
    await db.delete('notes', where: 'projectId = ?', whereArgs: [id]);
    return await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  // ── Notes ─────────────────────────────────────────────────

  Future<List<Note>> getNotes(int projectId) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'projectId = ?',
      whereArgs: [projectId],
      orderBy: 'updatedAt DESC',
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
