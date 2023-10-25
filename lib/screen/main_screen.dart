import 'package:flutter/material.dart';
import 'package:todo_list/model/todo_model.dart';
import 'package:todo_list/widget/input_widget.dart';
import 'package:todo_list/widget/list_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 할 일 목록을 저장하는 리스트
  List<Todo> todos = [
    Todo(title: 'Task 1', description: 'task 1', isCompleted: true),
    Todo(title: 'Task 2', description: 'task 2', isCompleted: false),
    Todo(title: 'Task 3', description: 'task 3', isCompleted: true),
    Todo(title: 'Task 4', description: 'task 4', isCompleted: false),
  ];

  // 할 일 삭제 함수
  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  // 할 일 추가 함수
  void addTodo(String title, String description) {
    setState(() {
      todos.add(
          Todo(title: title, description: description, isCompleted: false));
    });
  }

  // 할 일 완료/미완료 토글 함수
  void toggleIsCompleted(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  // 할 일을 입력하는 다이얼로그를 띄우는 함수
  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return InputDialogWidget(
          onTaskAdded: (title, description) {
            addTodo(title, description);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'), // 앱 상단 바의 제목
      ),
      body: ListWidget(
        todos: todos,
        removeTodo: removeTodo,
        toggleIsCompleted: toggleIsCompleted,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => displayTextInputDialog(context), // 추가 버튼
        child: const Icon(Icons.add), // '추가' 아이콘
      ),
    );
  }
}
