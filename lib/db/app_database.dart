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

  Future<Entry> getNewest() async { 
    try {
      Future<Entry> newest = _getNewestOrOldest(true);
      return newest;
    } catch(e){
      rethrow;
    }
  }
  
  Future<Entry> getOldest() async { 
    try {
      Future<Entry> oldest = _getNewestOrOldest(false);
      return oldest;
    } catch(e){
      rethrow;
    }
  }

  Future<Entry> _getNewestOrOldest(bool newest) async {
    final db = await instance.database;
    var orderBy = '${EntryFields.data} DESC';

    if(newest) {
      orderBy = '${EntryFields.data} ASC';
    }

    final maps = await db.query(
      tableEntries,
      columns: EntryFields.values,
      limit: 1,
      orderBy: orderBy
    );

    if(maps.isNotEmpty) {
      return Entry.fromJson(maps.first);
    } else {
      throw Exception('No entries');
    }
  }

  Future<int> numDiasFumou() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT distinct data FROM entries');
    final count = result.length;

    if(count > 0) {
      return count;
    } else {
      throw Exception('No entries');
    }
  }

  Future<Duration> numDiasSemFumarAtual() async {
    Entry newest = await getNewest();
    final DateTime data = newest.data;

    final diasSemFumar = DateTime.now().difference(data);

    if(diasSemFumar.inDays >= 0) {
      return diasSemFumar;
    } else {
      throw Exception('No entries');
    }
  }
 
  Future<int> numDiasSemFumarTotal() async {
    try {
      Entry oldest = await getOldest();
      final diasFumou = await numDiasFumou();

      final DateTime data = oldest.data;
      final diasTotais = DateTime.now().difference(data);

      final diasSemFumar = diasTotais.inDays - diasFumou;

      return diasSemFumar;
    } catch(e) {
      rethrow;
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