// ignore_for_file: constant_identifier_names

import '../Model/dog.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DogSQLiteDatabaseProvider {
  // 데이터베이스 파일 이름 및 테이블 이름 상수 정의
  static const String DATABASE_FILENAME = "dog_database.db";
  static const String DOGS_TABLENAME = "dogs";

  // 데이터베이스 제공자의 인스턴스를 저장하는 정적 변수
  static DogSQLiteDatabaseProvider databaseProvider =
      DogSQLiteDatabaseProvider._();
  static Database? _database; // 데이터베이스 객체

  // 생성자
  DogSQLiteDatabaseProvider._();

  // 클래스의 유일한 인스턴스를 반환하는 정적 메서드
  static DogSQLiteDatabaseProvider getDatabaseProvider() => databaseProvider;

  // 데이터베이스를 가져오는 비동기 메서드
  Future<Database> _getDatabase() async {
    return _database ??=
        await _initDatabase(); // null인 경우 _initDatabase()의 반환값을 _database에 저장하고 반환
  }

  // 데이터베이스 초기화 메서드
  Future<Database> _initDatabase() async {
    // 데이터베이스를 초기화하고 테이블을 생성
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_FILENAME),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $DOGS_TABLENAME(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            age TEXT)
            ''',
        );
      },
    );
  }

  // Dog 객체를 데이터베이스에 삽입하는 메서드
  Future<void> insertDog(Dog dog) async {
    Database database = await _getDatabase();
    database.insert(DOGS_TABLENAME, dog.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 데이터베이스에서 모든 Dog 항목을 가져오는 메서드
  Future<List<Dog>> getDogs() async {
    Database database = await _getDatabase();
    var maps = await database.query(DOGS_TABLENAME);

    List<Dog> dogList = List.empty(growable: true);
    for (Map<String, dynamic> map in maps) {
      dogList.add(Dog.fromMap(map)); // Map을 객체로 변환 후 todoList에 추가
    }
    return dogList;
  }

  // Todo 항목을 업데이트하는 메서드
  Future<void> updateDog(Dog dog) async {
    Database database = await _getDatabase();
    database.update(
      DOGS_TABLENAME,
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  // Todo 항목을 삭제하는 메서드
  Future<void> deleteDog(Dog dog) async {
    Database database = await _getDatabase();
    database.delete(DOGS_TABLENAME, where: 'id = ?', whereArgs: [dog.id]);
  }
}
