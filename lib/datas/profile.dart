import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Profile {
  static final Profile instance = Profile._init();

  static Database? _database;

  Profile._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('profile.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getApplicationCacheDirectory();
    final path = join(dbPath.path, filename);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT,
        name TEXT,
        city TEXT,
        headline TEXT,
        createdAt TEXT
      )
''');
  }

  Future<Map<String, dynamic>> profileCard(int id) async {
    final db = await instance.database;

    final result = await db.query('profile', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first as Map<String, dynamic>;
    } else {
      throw Exception('No profile found');
    }
  }

  Future<List<Map<String, dynamic>>> listProfile() async {
    final db = await instance.database;

    return db.query('profile');
  }

  Future<int> newProfile() async {
    final db = await instance.database;
    final result = await db.query(
      'profile',
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      throw Exception('No profile items found');
    }
  }

  Future<void> createProfile(
    String image,
    String name,
    String city,
    String headline,
  ) async {
    final db = await instance.database;

    await db.insert('profile', {
      'image': image,
      'name': name,
      'city': city,
      'headline': headline,
      'createdAt': DateTime.now().toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
