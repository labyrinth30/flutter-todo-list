// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'Model/dog.dart';

class DogCreate extends StatefulWidget {
  const DogCreate({super.key, required this.title});
  final String title;

  @override
  State<DogCreate> createState() => _DogCreate();
}

class _DogCreate extends State<DogCreate> {
  final TextEditingController _tecNameController = TextEditingController();
  final TextEditingController _tecAgeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _tecNameController,
                  decoration: const InputDecoration(
                    labelText: "강아지의 이름",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _tecAgeController,
                  decoration: const InputDecoration(
                    labelText: "강아지의 나이",
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text("저장"),
                onPressed: () {
                  if (_tecNameController.value.text.isEmpty ||
                      _tecAgeController.value.text.isEmpty) {
                    return;
                  }
                  Dog dog = Dog(
                    name: _tecNameController.value.text,
                    age: _tecAgeController.value.text,
                  );
                  Navigator.of(context).pop(dog);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
