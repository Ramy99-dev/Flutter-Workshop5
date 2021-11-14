import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workshop05/models/list_etudiants.dart';
import 'package:workshop05/models/scol_list.dart';


class dbuse {

  final int version = 1;
   Database db;
  static final dbuse _dbHelper = dbuse._internal();
  dbuse._internal();
  factory dbuse() {
  return _dbHelper;
  }
  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'scol.db'),
          onCreate: (database, version) {
            database.execute(
                'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT, nbreEtud INTEGER)');
            database.execute(
                'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER, nom TEXT, prenom TEXT, datNais TEXT, FOREIGN KEY(codClass) REFERENCES classes(codClass))');
          }, version: version);
    }
    return db;
  }

  Future<List<ScolList>> getClasses() async {
    final List<Map<String, dynamic>> maps = await db.query('classes');
    return List.generate(maps.length, (i) {
        return ScolList(
          maps[i]['codClass'],
          maps[i]['nomClass'],
          maps[i]['nbreEtud'],
        );
    });
  }
  Future<int> insertClass(ScolList list) async {
    int codClass = await this.db.insert(
      'classes',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return codClass;
  }

  Future<int> insertEtudiants(ListEtudiants etud) async {
    int id = await db.insert(
      'etudiants',
      etud.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<ListEtudiants>> getEtudiants(code) async {
    final List<Map<String, dynamic>> maps =
    await db.query('etudiants', where: 'codClass = ?', whereArgs:
    [code]);
    return List.generate(maps.length, (i) {
      return ListEtudiants(
        maps[i]['id'],
        maps[i]['codClass'],
        maps[i]['nom'],
        maps[i]['prenom'],
        maps[i]['datNais'],
      );
    });
  }

  Future deleteList(classe) async
  {

     await db.rawDelete('DELETE FROM classes WHERE codClass = ?', [classe.codClass]);

  }

  Future<int> deleteStudent(ListEtudiants student) async {
    int result =
    await db.delete("etudiants", where: "id = ?", whereArgs:
    [student.id]);
    return result;
  }






}