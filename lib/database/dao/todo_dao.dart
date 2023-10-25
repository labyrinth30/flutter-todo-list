import 'dart:async';
import 'package:todo_list/database/database.dart';
import 'package:todo_list/model/todo_model.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.provider;

  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;
    final result = db.insert(todoTable, todo.toDatabaseJson());
    return result;
  }

  Future<List<Todo>> getTodoList() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(todoTable);
    List<Todo> todoList = result.isNotEmpty
        ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];

    return todoList;
  }
}
