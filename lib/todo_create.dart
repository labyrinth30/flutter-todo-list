// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'Model/todo.dart';

class TodoCreate extends StatefulWidget {
  const TodoCreate({super.key, required this.title});
  final String title;

  @override
  State<TodoCreate> createState() => _TodoCreate();
}

class _TodoCreate extends State<TodoCreate> {
  final TextEditingController _tecTitleController = TextEditingController();
  final TextEditingController _tecContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Center(
              child: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _tecTitleController,
              decoration: const InputDecoration(
                labelText: "제목",
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _tecContentController,
            decoration: const InputDecoration(
              labelText: "할일",
            ),
          ),
        ),
        ElevatedButton(
          child: const Text("저장"),
          onPressed: () {
            Todo todo = Todo(
              title: _tecTitleController.value.text,
              content: _tecContentController.value.text,
              hasFinished: 0,
            );
            Navigator.of(context).pop(todo);
          },
        )
      ]))),
    );
  }
}
