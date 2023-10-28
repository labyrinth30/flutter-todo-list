// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:todo_list_gdsc/Screen/todo_create_screen.dart';
import 'package:todo_list_gdsc/Util/todo_sqlite_database.dart';
import 'package:todo_list_gdsc/Model/todo.dart';
import 'package:todo_list_gdsc/theme/theme.provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.title,
    required this.database,
  });

  final String title;
  final TodoSQLiteDatabase database;

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();
    todoList = _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: const Icon(Icons.brightness_4),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
        ),
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
                          return Dismissible(
                            // 스와이프 기능
                            key: Key(todo.id.toString()), // 식별자는 dog의 id
                            direction:
                                DismissDirection.endToStart, // 방향은 우측에서 왼쪽으로
                            onDismissed: (direction) {
                              // 스와이프가 완료되면 호출
                              _deleteTodo(todo);
                            },
                            background: Container(
                              // DogCard 뒤에 빨간 배경을 추가
                              color: Colors.red,
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.centerRight, // 오른쪽 정렬 추가
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  // 화면 전체를 차지하도록 확장
                                  child: ListTile(
                                    title: Text(todo.title!,
                                        style: const TextStyle(fontSize: 16)),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Text(todo.content!),
                                        Text(todo.hasFinished == 1
                                            ? "완료"
                                            : "미완료"),
                                      ],
                                    ),
                                    onTap: () {
                                      _updateTodo(todo);
                                    },
                                    onLongPress: () {
                                      _deleteTodo(todo);
                                    },
                                  ),
                                ),
                              ],
                            ),
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          _createTodo();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Todo>> _getTodos() {
    return widget.database.getTodos();
  }

  Future<void> _createTodo() async {
    // Todo? todo = await Navigator.push(
    //   context,
    //   MaterialPageRoute( // MaterialPageRoute은 stateless widget을 route로 감싸서 widget을 screen 처럼 보이게 함
    //     builder: ((context) => const TodoCreateScreen(title: 'To Do Create')),
    //   ),
    // ) as Todo?;
    Todo? todo = await Navigator.of(context).pushNamed('/create')
        as Todo?; // 생성 후 반환된 Todo를 명시
    if (todo != null) {
      // 반환된 Todo가 null이 아닌 경우에만 실행될 코드
      widget.database.insertTodo(todo);
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
                        labelText: "할 일",
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
                Navigator.of(context).pop(todo); // 수정된 todo를 반환
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
      widget.database.updateTodo(updatedTodo);
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
      await widget.database.deleteTodo(todo);
      setState(
        () {
          todoList = _getTodos();
        },
      );
    }
  }
}
