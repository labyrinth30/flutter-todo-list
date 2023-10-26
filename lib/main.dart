import 'package:flutter/material.dart';
import 'package:todo_list/Util/dog_sqlite_database_provider.dart';
import 'package:todo_list/dog_create.dart';
import 'material_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DogSQLiteDatabaseProvider databaseProvider =
        DogSQLiteDatabaseProvider.getDatabaseProvider();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MaterialMain(
              title: 'Dog List',
              databaseProvider: databaseProvider,
            ),
        '/create': (context) => const DogCreate(title: 'Dog Create'),
      },
    );
  }
}
