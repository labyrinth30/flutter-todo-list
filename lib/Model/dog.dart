class Dog {
  int? id;
  String? name;
  String? age;

  Dog({
    this.id,
    this.name,
    this.age,
  });

  Dog.fromMap(Map<String, dynamic> map) {
    //Map을 객체로 만들어 주는 named constructor
    id = map['id'];
    name = map['name'];
    age = map['age'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}
