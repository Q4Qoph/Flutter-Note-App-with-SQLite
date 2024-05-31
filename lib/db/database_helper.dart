import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _dbName = 'sticky_notes.db';
  static final _tableSticky = 'sticky';
  static final _tableNotes = 'notes';

  static final StreamController<void> _dbChangesStreamController =
      StreamController<void>.broadcast();

  Stream<void> get dbChangesStream => _dbChangesStreamController.stream;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableSticky(
        id INTEGER PRIMARY KEY,
        body TEXT,
        creation_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableNotes(
        id INTEGER PRIMARY KEY,
        title TEXT,
        body TEXT,
        creation_date TEXT
      )
    ''');
  }

  Future<int> insertSticky(
    {required String body, required DateTime creationDate}) async {
    final truncatedCreationDate = DateTime(
      creationDate.year,
      creationDate.month,
      creationDate.day,
      creationDate.hour,
      creationDate.minute,
    );
    final db = await database;
    final result = await db.insert(_tableSticky, {
      'body': body,
      'creation_date': truncatedCreationDate.toIso8601String()
    });
    _dbChangesStreamController.add(null);
    return result;
  }

  Future<int> insertNote(
      {required String title,
      required String body,
      required DateTime creationDate}) async {
    final truncatedCreationDate = DateTime(
      creationDate.year,
      creationDate.month,
      creationDate.day,
      creationDate.hour,
      creationDate.minute,
    );
    final db = await database;
    final result = await db.insert(_tableNotes, {
      'title': title,
      'body': body,
      'creation_date': truncatedCreationDate.toIso8601String(),
    });
    _dbChangesStreamController.add(null);
    return result;
  }

  Future<int> updateNote({
    required String oldTitle,
    required String newTitle,
    required String newContent,
  }) async {
    final db = await database;
    final result = await db.update(
      _tableNotes,
      {'title': newTitle, 'body': newContent},
      where: 'title = ?',
      whereArgs: [oldTitle],
    );
    _dbChangesStreamController.add(null);
    return result;
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    final result =
        await db.delete(_tableNotes, where: 'id = ?', whereArgs: [id]);
    _dbChangesStreamController.add(null);
    return result;
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return db.query(_tableNotes);
  }

  Future<List<Map<String, dynamic>>> getSticky() async {
    final db = await database;
    return db.query(_tableSticky);
  }
}
