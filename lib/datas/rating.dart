import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Rating {
  static final Rating instance = Rating._init();

  static Database? _database;

  Rating._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('rating.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getApplicationCacheDirectory();
    final path = join(dbPath.path, filename);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rating(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER,
        rating REAL,
        createdAt TEXT
      )
''');
  }

  Future<double> rating(int id) async {
    final db = await instance.database;

    final result = await db.rawQuery(
      'SELECT AVG(rating) as avg_rating FROM rating WHERE profile_id = ?',
      [id],
    );

    if (result.isNotEmpty && result.first['avg_rating'] != null) {
      return (result.first['avg_rating'] as num).toDouble();
    } else {
      return 0.0;
    }
  }

  Future<List<Map<String, dynamic>>> listRating() async {
    final db = await instance.database;

    return await db.query('rating', orderBy: 'id DESC');
  }

  Future<void> insertRating(int id, double rating) async {
    final db = await instance.database;

    await db.insert('rating', {
      'profile_id': id,
      'rating': rating,
      'createdAt': DateTime.now().toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
