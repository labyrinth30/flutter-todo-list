// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class InputDialogWidget extends StatefulWidget {
  final Function(String, String) onTaskAdded; // 할 일 추가 콜백 함수

  const InputDialogWidget({super.key, required this.onTaskAdded});

  @override
  _InputDialogWidgetState createState() => _InputDialogWidgetState();
}

class _InputDialogWidgetState extends State<InputDialogWidget> {
  TextEditingController titleController = TextEditingController(); // 제목 입력 컨트롤러
  TextEditingController descriptionController =
      TextEditingController(); // 설명 입력 컨트롤러

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Task'), // 다이얼로그 제목
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Enter title...', // 제목 입력 힌트
              border: OutlineInputBorder(), // 외곽선 스타일
              labelText: 'Title', // 제목 레이블
            ),
          ),
          const SizedBox(height: 10), // 필드 간 간격 조절
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter description...', // 설명 입력 힌트
              border: OutlineInputBorder(), // 외곽선 스타일
              labelText: 'Description', // 설명 레이블
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
            widget.onTaskAdded(
              titleController.text, // 제목 전달
              descriptionController.text, // 설명 전달
            );
          },
          child: const Text('OK'), // 확인 버튼
        ),
      ],
    );
  }
}
