import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// 할 일 목록을 저장할 테이블 이름
const todoTable = 'todo_table';

class DatabaseProvider {
  static final DatabaseProvider provider = DatabaseProvider();

  late Database _database;

  // 생성자에서 데이터베이스를 생성
  DatabaseProvider() {
    createDatabase();
  }

  // 데이터베이스를 비동기로 가져오는 함수
  Future<Database> get database async {
    return _database;
  }

  // 데이터베이스를 생성하는 함수
  Future<Database> createDatabase() async {
    // 앱 문서 디렉토리 경로 획득
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, "todo.db");

    // 데이터베이스 열기
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  // 데이터베이스 업그레이드 시 호출되는 함수
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // TODO :: Migration (데이터베이스 업그레이드 코드 추가)
    }
  }

  // 초기 데이터베이스 스키마 설정
  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $todoTable ("
        "id INTEGER PRIMARY KEY, "
        "title TEXT, "
        "state INTEGER, "
        "created_time INTEGER"
        ")");
  }
}
