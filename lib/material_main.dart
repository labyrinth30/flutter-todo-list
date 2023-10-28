// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:todo_list/Widget/dog_card.dart';
import 'Model/dog.dart';
import 'Util/dog_sqlite_database_provider.dart';

class MaterialMain extends StatefulWidget {
  const MaterialMain(
      {super.key, required this.title, required this.databaseProvider});
  final String title;
  final DogSQLiteDatabaseProvider databaseProvider;

  @override
  State<MaterialMain> createState() => _MaterialMain();
}

class _MaterialMain extends State<MaterialMain> {
  Future<List<Dog>>? dogList;

  @override
  void initState() {
    super.initState();
    dogList = _getDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: dogList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 연결 상태가 로딩중이면
                return const CircularProgressIndicator(); // 로딩 표시기 표시
              } else if (snapshot.connectionState == ConnectionState.done) {
                // 연결 완료 상태이면
                if (snapshot.hasError) {
                  // dogList에 문제가 있으면
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  // dogList를 올바르게 가져왔다면
                  return ListView.separated(
                    itemCount:
                        (snapshot.data as List<Dog>).length, // 형 변환 후 length 사용
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black.withOpacity(0.8),
                        thickness: 1,
                        height: 1,
                      );
                    },
                    itemBuilder: (context, index) {
                      Dog dog = (snapshot.data as List<Dog>)[index];
                      return GestureDetector(
                        onTap: () => _updateDog(
                          dog,
                        ),
                        onLongPress: () {
                          _deleteDog(dog);
                        },
                        child: Dismissible(
                          // 스와이프 기능
                          key: Key(dog.id.toString()), // 식별자는 dog의 id
                          direction:
                              DismissDirection.endToStart, // 방향은 우측에서 왼쪽으로
                          onDismissed: (direction) {
                            // 스와이프가 완료되면 호출
                            _deleteDog(dog);
                          },
                          background: Container(
                            // DogCard 뒤에 빨간 배경을 추가
                            color: Colors.red,
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.centerRight, // 오른쪽 정렬 추가
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                // 화면 전체를 차지하도록 확장
                                child: DogCard(dog: dog),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text("Empty data");
                }
              } else {
                return Text("ConnectionState: ${snapshot.connectionState}");
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () {
          _createDogs();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Dog>> _getDogs() {
    return widget.databaseProvider.getDogs();
  }

  Future<void> _createDogs() async {
    Dog? dog = await Navigator.of(context).pushNamed('/create') as Dog?;
    if (dog != null) {
      // 반환된 dog가 null이 아닌 경우에만 실행될 코드
      widget.databaseProvider.insertDog(dog);
      setState(
        () {
          dogList = _getDogs();
        },
      );
    }
  }

  Future<void> _updateDog(Dog dog) async {
    TextEditingController tecAgeController =
        TextEditingController(text: dog.age);

    Dog? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${dog.id}: ${dog.name}"),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SizedBox(
                height: 150,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: tecAgeController,
                      decoration: const InputDecoration(
                        labelText: "강아지의 나이",
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              child: const Text("수정"),
              onPressed: () {
                dog.age = tecAgeController.value.text;
                Navigator.of(context).pop(dog);
              },
            ),
            ElevatedButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(); // null을 반환
              },
            )
          ],
        );
      },
    );

    if (res != null) {
      Dog updatedDog = res;
      widget.databaseProvider.updateDog(updatedDog);
      setState(
        () {
          dogList = _getDogs();
        },
      );
    }
  }

  Future<void> _deleteDog(Dog dog) async {
    bool? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${dog.id}: ${dog.name}"),
          content: const Text("삭제하시겠습니까?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("삭제"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      },
    );

    if (res != null && res) {
      await widget.databaseProvider.deleteDog(dog);
      setState(
        () {
          dogList = _getDogs();
        },
      );
    } else {
      setState(() {
        dogList = _getDogs();
      });
    }
  }
}
