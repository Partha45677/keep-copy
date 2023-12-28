import 'package:keepnote/Services/firestoredb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:keepnote/Services/databaseModel.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Notes.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE ${NotesImpNames.TableName} (
      ${NotesImpNames.id} $idType,
      ${NotesImpNames.pin} $boolType,
      ${NotesImpNames.isArchieve} $boolType,
      ${NotesImpNames.title} $textType,
      ${NotesImpNames.content} $textType,
      ${NotesImpNames.createdTime} $textType
    )
  ''');
  }

  Future<Note?> insertEntry(Note note) async {
    final db = await instance.database;
    final id = await db!.insert(NotesImpNames.TableName, note.toJson());
    await FireDB().createNewNoteFireStore(note);
    return note.copy(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NotesImpNames.createdTime} ASC';
    final query_result =
        await db!.query(NotesImpNames.TableName, orderBy: orderBy);
    return query_result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NotesImpNames.TableName,
        columns: NotesImpNames.values,
        where: '${NotesImpNames.id}=?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    } else {
      return null;
    }
  }

  Future<int> updateNote(Note note) async {
    await FireDB().updateNoteFirestore(note);
    final db = await instance.database;
    return db!.update(NotesImpNames.TableName, note.toJson(),
        where: '${NotesImpNames.id}=?', whereArgs: [note.id]);
  }

  Future<int> pinNote(Note note) async {
    final db = await instance.database;
    return db!.update(
        NotesImpNames.TableName, {NotesImpNames.pin: !note.pin ? 1 : 0},
        where: '${NotesImpNames.id}=?', whereArgs: [note.id]);
  }

  Future<int> archieNote(Note note) async {
    final db = await instance.database;
    return db!.update(NotesImpNames.TableName,
        {NotesImpNames.isArchieve: !note.isArchieve ? 1 : 0},
        where: '${NotesImpNames.id}=?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(Note note) async {
    await FireDB().deleteNoteFirestore(note);
    final db = await instance.database;
    return db!.delete(NotesImpNames.TableName,
        where: '${NotesImpNames.id}=?', whereArgs: [note.id]);
  }

  Future closeDB() async {
    final db = await instance.database;
    db!.close();
  }

  Future<List<int>> getNoteString(String query) async {
    final db = await instance.database;
    final result = await db!.query(NotesImpNames.TableName);
    List<int> ResultIds = [];
    result.forEach((element) {
      if (element["title"].toString().toLowerCase().contains(query) ||
          element["content"].toString().toLowerCase().contains(query)) {
        ResultIds.add(element["id"] as int);
      }
    });

    return ResultIds;
  }

  Future<List<Note>> readArchivedNotes() async {
    final db = await instance.database;
    final whereClause = '${NotesImpNames.isArchieve} = ?';
    final whereArgs = [1]; // 1 represents true for BOOLEAN in SQLite

    final queryResult = await db!.query(
      NotesImpNames.TableName,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readNormaldNotes() async {
    final db = await instance.database;
    final whereClause =
        '${NotesImpNames.isArchieve} = ? AND ${NotesImpNames.pin} = ?';
    final whereArgs = [0, 0]; // 1 represents true for BOOLEAN in SQLite

    final queryResult = await db!.query(
      NotesImpNames.TableName,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readpinedNotes() async {
    final db = await instance.database;
    final whereClause =
        '${NotesImpNames.pin} = ? AND ${NotesImpNames.isArchieve} = ?';
    final whereArgs = [1, 0]; // 1 represents true for BOOLEAN in SQLite

    final queryResult = await db!.query(
      NotesImpNames.TableName,
      where: whereClause,
      whereArgs: whereArgs,
    );

    return queryResult.map((json) => Note.fromJson(json)).toList();
  }
}
