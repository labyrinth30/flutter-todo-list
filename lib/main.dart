import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_gdsc/Screen/main_screen.dart';
import 'package:todo_list_gdsc/Screen/todo_create_screen.dart';
import 'package:todo_list_gdsc/Util/todo_sqlite_database.dart';
import 'package:todo_list_gdsc/theme/theme.dart';
import 'package:todo_list_gdsc/theme/theme.provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 데이터베이스 프로바이더 생성
    TodoSQLiteDatabase database = TodoSQLiteDatabase.getDatabase();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        // 루트 경로 설정: MainScreen으로 이동
        '/': (context) => MainScreen(title: 'To Do List', database: database),
        // '/create' 경로 설정: TodoCreateScreen으로 이동
        '/create': (context) => const TodoCreateScreen(title: 'To Do Create'),
      },
    );
  }
}
