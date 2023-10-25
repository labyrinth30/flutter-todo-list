class Todo {
  // 할 일의 제목
  String title;

  // 할 일의 설명
  String description;

  // 할 일이 완료되었는지 여부
  bool isCompleted;

  // 생성자
  Todo({
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  // 데이터베이스에서 데이터를 읽어 Todo 객체로 변환하는 팩토리 메서드
  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        title: data['title'] as String,
        description: data['description'] as String,
        isCompleted: data['isCompleted'] == 1, // 1은 true, 0은 false로 가정합니다
      );

  // Todo 객체를 데이터베이스에 저장하기 위한 메서드
  Map<String, dynamic> toDatabaseJson() => {
        'title': title,
        'description': description,
        'isCompleted': isCompleted ? 1 : 0, // true면 1, false면 0으로 저장합니다
      };
}
