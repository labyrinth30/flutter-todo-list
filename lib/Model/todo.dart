class Todo {
  //데이터 모델 정의
  int? id;
  String? title;
  String? content;
  int? hasFinished;

  Todo({
    this.id,
    this.title,
    this.content,
    this.hasFinished,
  });

  Todo.fromMap(Map<String, dynamic> map) {
    //Map을 객체로 만들어 주는 named constructor
    id = map['id'];
    title = map['title'];
    content = map['content'];
    hasFinished = map['hasFinished'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'hasFinished': hasFinished,
    };
  }
}
