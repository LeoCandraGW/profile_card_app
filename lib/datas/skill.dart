import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Skill {
  static final Skill instance = Skill._init();

  static Database? _database;

  Skill._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('skill.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getApplicationCacheDirectory();
    final path = join(dbPath.path, filename);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE skill(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        name TEXT,
        createdAt TEXT
      )
''');
  }

  Future<List<Map<String, dynamic>>> listSkill(int id) async {
    final db = await instance.database;

    return db.query('skill', where: 'profile_id = ?', whereArgs: [id]);
  }

  Future<void> createSkill(int id, String name) async {
    final db = await instance.database;

    await db.insert('skill', {
      'profile_id': id,
      'name': name,
      'createdAt': DateTime.now().toString(),
    });
  }
}
