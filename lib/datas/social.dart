import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Social {
  static final Social instance = Social._init();

  static Database? _database;

  Social._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('social.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getApplicationCacheDirectory();
    final path = join(dbPath.path, filename);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE social(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        url TEXT,
        profile_id
      )
''');
  }

  Future<void> createSocial(String name, String url, int id) async {
    final db = await instance.database;

    await db.insert('social', {
      'name': name,
      'url': url,
      'profile_id': id,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> listSocial() async {
    final db = await instance.database;

    return await db.query('social');
  }
}
