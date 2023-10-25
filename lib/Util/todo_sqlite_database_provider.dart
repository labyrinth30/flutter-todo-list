// ignore_for_file: constant_identifier_names

import '../Model/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoSQLiteDatabaseProvider {
  static const String DATABASE_FILENAME = "todo_database.db";
  static const String TODOS_TABLENAME = "todos";

  static TodoSQLiteDatabaseProvider databaseProvider =
      TodoSQLiteDatabaseProvider._();
  static Database? _database; //데이터베이스 객체

  TodoSQLiteDatabaseProvider._(); //생성자

  static TodoSQLiteDatabaseProvider getDatabaseProvider() =>
      databaseProvider; //databaseProvider 반환 함수

  Future<Database> _getDatabase() async {
    return _database ??=
        await _initDatabase(); //null인 경우 _initDatabase()의 반환값을 _database에 저장하고 반환
  }

  Future<Database> _initDatabase() async {
    //DB 초기화
    return openDatabase(join(await getDatabasesPath(), DATABASE_FILENAME),
        version: 1, onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $TODOS_TABLENAME(id INTEGER PRIMARY KEY, title TEXT, content TEXT, hasFinished INT)");
    });
  }

  Future<void> insertTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.insert(TODOS_TABLENAME, todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> getTodos() async {
    Database database = await _getDatabase();
    var maps = await database.query(TODOS_TABLENAME);

    List<Todo> todoList = List.empty(growable: true);
    for (Map<String, dynamic> map in maps) {
      todoList.add(Todo.fromMap(map)); //Map을 객체로 변환 후 todoList에 추가
    }
    return todoList;
  }

  Future<void> updateTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.update(TODOS_TABLENAME, todo.toMap(),
        where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.delete(TODOS_TABLENAME, where: 'id = ?', whereArgs: [todo.id]);
  }
}
