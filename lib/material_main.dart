// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'Model/todo.dart';
import 'Util/todo_sqlite_database_provider.dart';

class MaterialMain extends StatefulWidget {
  const MaterialMain(
      {super.key, required this.title, required this.databaseProvider});
  final String title;
  final TodoSQLiteDatabaseProvider databaseProvider;

  @override
  State<MaterialMain> createState() => _MaterialMain();
}

class _MaterialMain extends State<MaterialMain> {
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
      body: Container(
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
                  itemCount:
                      (snapshot.data as List<Todo>).length, //형 변환 후 length 사용
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
        )),
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
    Todo todo =
        await Navigator.of(context).pushNamed('/create') as Todo; //Todo로 다운캐스팅
    widget.databaseProvider.insertTodo(todo);
    setState(() {
      todoList = _getTodos();
    });
  }

  Future<void> _updateTodo(Todo todo) async {
    TextEditingController tecContentController =
        TextEditingController(text: todo.content);
    bool isChecked = (todo.hasFinished == 1) ? true : false;

    Todo res = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //상태는 바뀌지만 화면이 갱신되지 않음 (AlertDialog는 Stateless 위젯)
            title: Text("${todo.id}: ${todo.title}"),
            content: StatefulBuilder(
              //StatefulBuilder를 이용하여 화면 갱신
              builder: (context, setDialogState) {
                return Container(
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
                          setDialogState(() {
                            isChecked = value!;
                          });
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
                  Navigator.of(context).pop(); //null을 반환
                },
              )
            ],
          );
        });

    widget.databaseProvider.updateTodo(res);
    setState(() {
      todoList = _getTodos();
    });
  }

  Future<void> _deleteTodo(Todo todo) async {
    var res = await showDialog(
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
        });

    if (res) {
      await widget.databaseProvider.deleteTodo(todo);
      setState(() {
        todoList = _getTodos();
      });
    }
  }
}
