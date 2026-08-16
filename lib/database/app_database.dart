import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'movie_match.db');

    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            type TEXT NOT NULL,
            title TEXT NOT NULL,
            overview TEXT,
            poster_path TEXT,
            backdrop_path TEXT,
            release_date TEXT,
            vote_average REAL,
            genre_ids TEXT,
            created_at INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE skipped_media (
            id INTEGER PRIMARY KEY,
            type TEXT NOT NULL,
            title TEXT NOT NULL,
            overview TEXT,
            poster_path TEXT,
            backdrop_path TEXT,
            release_date TEXT,
            vote_average REAL,
            genre_ids TEXT,
            created_at INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS skipped_media (
              id INTEGER PRIMARY KEY,
              type TEXT NOT NULL,
              title TEXT NOT NULL,
              overview TEXT,
              poster_path TEXT,
              backdrop_path TEXT,
              release_date TEXT,
              vote_average REAL,
              genre_ids TEXT,
              created_at INTEGER NOT NULL
            )
          ''');
        }

        if (oldVersion < 3) {
          await db.execute('ALTER TABLE favorites ADD COLUMN genre_ids TEXT');
          await db.execute(
            'ALTER TABLE skipped_media ADD COLUMN genre_ids TEXT',
          );
        }
      },
    );
  }
}
