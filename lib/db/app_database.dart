import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/model/entry.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;
  
  AppDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final quantidadeType = 'INTEGER NOT NULL';
    final dataType = 'DATETIME NOT NULL';

    await db.execute ('''CREATE TABLE $tableEntries (
      ${EntryFields.id} $idType,
      ${EntryFields.quantidade} $quantidadeType,
      ${EntryFields.data} $dataType 
    )
    ''');
  }

  Future<Entry> create(Entry entry) async {
    final db = await instance.database;

    final id = await db.insert(tableEntries, entry.toJson());

    return entry.copy(id: id);
  }

  Future<Entry> readEntry(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableEntries,
      columns: EntryFields.values,
      where: '${EntryFields.id} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty) {
      return Entry.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> update(Entry entry) async {
    final db = await instance.database;

    return db.update(
      tableEntries, 
      entry.toJson(),
      where: '${EntryFields.id} = ?',
      whereArgs: [entry.id],
      );
  }

  Future <int> delete(int id) async {
    final db = await instance.database;

    return db.delete(
      tableEntries,
      where: '${EntryFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Entry>> readAllEntries() async {
    final db = await instance.database;

    final orderBy = '${EntryFields.data} DESC';

    final result = await db.query(tableEntries, orderBy: orderBy);

    return result.map((json) => Entry.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

}