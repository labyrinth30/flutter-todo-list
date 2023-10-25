import 'package:flutter/material.dart';
import 'package:todo_list/Util/todo_sqlite_database_provider.dart';
import 'package:todo_list/todo_create.dart';
import 'package:todo_list/todo_finished.dart';
import 'material_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TodoSQLiteDatabaseProvider databaseProvider =
        TodoSQLiteDatabaseProvider.getDatabaseProvider();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MaterialMain(
            title: 'To Do List', databaseProvider: databaseProvider),
        '/create': (context) => const TodoCreate(title: 'To Do Create'),
        '/finished': (context) => const TodoFinished(title: 'To Do Finished'),
      },
    );
  }
}
