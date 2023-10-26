import 'package:flutter/material.dart';
import 'package:todo_list_gdsc/Screen/main_screen.dart';
import 'package:todo_list_gdsc/Screen/todo_create_screen.dart';
import 'package:todo_list_gdsc/Util/todo_sqlite_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TodoSQLiteDatabase databaseProvider = TodoSQLiteDatabase.getDatabase();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            MainScreen(title: 'To Do List', databaseProvider: databaseProvider),
        '/create': (context) => const TodoCreateScreen(title: 'To Do Create'),
      },
    );
  }
}
