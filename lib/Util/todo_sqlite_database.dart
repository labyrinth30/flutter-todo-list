// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list_gdsc/Model/todo.dart';

class TodoSQLiteDatabase {
  // 데이터베이스 파일 이름 및 테이블 이름 상수 정의
  static const String DATABASE_FILENAME = "todo_database.db";
  static const String TODOS_TABLENAME = "todos";

  // 클래스의 인스턴스를 만들어서 저장하고, 다른 부분에서 이 도구를 사용하여 데이터베이스에 액세스합니다.
  static TodoSQLiteDatabase database = TodoSQLiteDatabase._();

  // 생성자
  TodoSQLiteDatabase._();

  // 데이터베이스 객체
  static Database? _database;

  // 데이터베이스의 getter
  static TodoSQLiteDatabase getDatabase() => database;

  // 데이터베이스를 가져오는 비동기 메서드
  Future<Database> _getDatabase() async {
    return _database ??=
        await _initDatabase(); // null인 경우 _initDatabase()의 반환값을 _database에 저장하고 반환
  }

  // 데이터베이스를 초기화하는 비동기 메서드
  Future<Database> _initDatabase() async {
    // 데이터베이스를 초기화하고 테이블을 생성
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_FILENAME),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $TODOS_TABLENAME(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            hasFinished INTEGER
          )
          ''');
      },
    );
  }

  // Todo 객체를 데이터베이스에 추가하는 비동기 메서드
  Future<void> insertTodo(Todo todo) async {
    Database database = await _getDatabase();
    database.insert(
      TODOS_TABLENAME,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> getTodos() async {
    Database database = await _getDatabase();

    List<Map<String, dynamic>> result = await database.query(
      TODOS_TABLENAME,
    );

    List<Todo> todoList = List.empty(growable: true);
    for (var todo in result) {
      todoList.add(Todo.fromMap(todo));
    }
    return todoList;
  }

  // Todo 항목을 업데이트하는 메서드
  Future<void> updateTodo(Todo todo) async {
    Database database = await _getDatabase();
    await database.update(
      TODOS_TABLENAME, // table 이름
      todo.toMap(), // 업데이트 할 value
      where: "id = ?", // 어떤 todo를 업데이트할 것 인지
      whereArgs: [todo.id], // 업데이트할 todo의 id
    );
    //await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  // Todo 항목을 삭제하는 메서드
  Future<void> deleteTodo(Todo todo) async {
    Database database = await _getDatabase();
    await database.delete(
      TODOS_TABLENAME,
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }
}
// await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
