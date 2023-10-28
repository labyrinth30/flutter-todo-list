import 'package:flutter/material.dart';
import 'package:todo_list/Model/dog.dart';

class DogCard extends StatelessWidget {
  const DogCard({
    Key? key,
    required this.dog,
  }) : super(key: key);

  final Dog dog;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // 그림자 추가
      margin: const EdgeInsets.all(10), // 여백 추가
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              dog.name!,
              style: const TextStyle(
                fontSize: 18, // 더 큰 폰트 크기
                fontWeight: FontWeight.bold, // 굵은 글꼴
              ),
            ),
            const SizedBox(height: 8), // 간격 추가
            Text(
              '나이: ${dog.age}세', // 나이 정보 추가
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
