// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:todo_list_gdsc/Util/todo_sqlite_database.dart';
import 'package:todo_list_gdsc/Model/todo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.title,
    required this.databaseProvider,
  });
  final String title;
  final TodoSQLiteDatabase databaseProvider;

  @override
  State<MainScreen> createState() => _MaterialMain();
}

class _MaterialMain extends State<MainScreen> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();
    todoList = _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: FutureBuilder(
                future: todoList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return ListView.separated(
                        itemCount: (snapshot.data as List<Todo>)
                            .length, //형 변환 후 length 사용
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            color: Colors.blueGrey,
                          );
                        },
                        itemBuilder: (context, index) {
                          Todo todo = (snapshot.data as List<Todo>)[index];
                          return ListTile(
                            title: Text(todo.title!,
                                style: const TextStyle(fontSize: 16)),
                            subtitle: Column(
                              children: <Widget>[
                                Text(todo.content!),
                                Text(todo.hasFinished == 1 ? "완료" : "미완료"),
                              ],
                            ),
                            onTap: () {
                              _updateTodo(todo);
                            },
                            onLongPress: () {
                              _deleteTodo(todo);
                            },
                          );
                        },
                      );
                    } else {
                      return const Text("Empty data");
                    }
                  } else {
                    return Text("ConnectionState: ${snapshot.connectionState}");
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _createTodo();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<List<Todo>> _getTodos() {
    return widget.databaseProvider.getTodos();
  }

  Future<void> _createTodo() async {
    Todo? todo = await Navigator.of(context).pushNamed('/create') as Todo?;
    if (todo != null) {
      // 반환된 Todo가 null이 아닌 경우에만 실행될 코드
      widget.databaseProvider.insertTodo(todo);
      setState(() {
        todoList = _getTodos();
      });
    }
  }

  Future<void> _updateTodo(Todo todo) async {
    TextEditingController tecContentController =
        TextEditingController(text: todo.content);
    bool isChecked = (todo.hasFinished == 1) ? true : false;

    Todo? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${todo.id}: ${todo.title}"),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SizedBox(
                height: 150,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tecContentController,
                      decoration: const InputDecoration(
                        labelText: "할일",
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text("완료 여부"),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setDialogState(
                          () {
                            isChecked = value!;
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("수정"),
              onPressed: () {
                todo.content = tecContentController.value.text;
                todo.hasFinished = isChecked ? 1 : 0;
                Navigator.of(context).pop(todo);
              },
            ),
            ElevatedButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(); // null을 반환
              },
            )
          ],
        );
      },
    );

    if (res != null) {
      Todo updatedTodo = res;
      widget.databaseProvider.updateTodo(updatedTodo);
      setState(
        () {
          todoList = _getTodos();
        },
      );
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    bool? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${todo.id}: ${todo.title}"),
          content: const Text("삭제하시겠습니까?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("삭제"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      },
    );

    if (res != null && res) {
      await widget.databaseProvider.deleteTodo(todo);
      setState(
        () {
          todoList = _getTodos();
        },
      );
    }
  }
}
