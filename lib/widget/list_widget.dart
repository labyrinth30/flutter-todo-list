import 'package:flutter/material.dart';
import 'package:todo_list/model/todo_model.dart';

class ListWidget extends StatelessWidget {
  final List<Todo> todos;
  final Function(int) removeTodo;
  final Function(int) toggleIsCompleted;

  const ListWidget({
    required this.todos,
    required this.removeTodo,
    required this.toggleIsCompleted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 20, // 리스트 아이템 간의 간격
        );
      },
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(DateTime.now().toString()), // 키는 card의 인덱스
          direction: DismissDirection.endToStart, // 우측에서 왼쪽으로 스와이프
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              removeTodo(index); // 우측에서 왼쪽으로 스와이프 시 삭제
            }
          },

          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              title: Text(
                todos[index].title, // 할 일의 제목
                style: TextStyle(
                  decoration: todos[index].isCompleted
                      ? TextDecoration.lineThrough // 완료된 항목에 줄 긋기
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                todos[index].description, // 할 일의 설명
                style: TextStyle(
                  decoration: todos[index].isCompleted
                      ? TextDecoration.lineThrough // 완료된 항목에 줄 긋기
                      : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red), // 삭제 아이콘
                onPressed: () => removeTodo(index),
              ),
              onTap: () => toggleIsCompleted(index), // 탭 시 완료 상태 변경
            ),
          ),
        );
      },
      itemCount: todos.length, // 리스트 아이템 수
    );
  }
}
