import 'package:flutter/material.dart';
import 'package:todo_list/screen/main_screen.dart';

void main() {
  // 앱 실행을 시작하는 지점
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 화면의 어떤 부분이든 터치하면 키보드가 숨겨짐
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      // 앱의 루트 위젯으로 MaterialApp을 사용
      child: const MaterialApp(
        // 앱의 첫 화면을 MainScreen으로 설정
        home: MainScreen(),
      ),
    );
  }
}
