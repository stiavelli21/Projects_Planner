class Project {
  int? id;
  String title;
  String description;
  DateTime createdAt;
  int colorIndex;
  int noteCount; // Not stored in DB, computed at query time

  Project({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.colorIndex = 0,
    this.noteCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'colorIndex': colorIndex,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      colorIndex: map['colorIndex'] as int? ?? 0,
      noteCount: map['noteCount'] as int? ?? 0,
    );
  }
}
