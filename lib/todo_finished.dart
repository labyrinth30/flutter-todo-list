import 'package:flutter/material.dart';

class TodoFinished extends StatefulWidget {
  const TodoFinished({super.key, required this.title});
  final String title;

  @override
  State<TodoFinished> createState() => _TodoFinished();
}

class _TodoFinished extends State<TodoFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
    );
  }
}
