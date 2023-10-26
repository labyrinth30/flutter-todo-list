// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
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
    dogList = _getdogs();
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
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: (snapshot.data)?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 2,
                      );
                    },
                    itemBuilder: (context, index) {
                      final List<Dog>? dogList = snapshot.data;
                      if (dogList != null && index < dogList.length) {
                        final Dog dog = dogList[index];
                        return GestureDetector(
                            onTap: () => _updateDog(
                                  dog,
                                ),
                            onLongPress: () {
                              _deleteDog(dog);
                            },
                            child: Card(
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
                            ));
                      }
                      return const SizedBox
                          .shrink(); // 이 경우 빈 상자를 반환하여 아무것도 표시하지 않음
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
          _createdogs();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Dog>> _getdogs() {
    return widget.databaseProvider.getDogs();
  }

  Future<void> _createdogs() async {
    Dog? dog = await Navigator.of(context).pushNamed('/create') as Dog?;
    if (dog != null) {
      // 반환된 dog가 null이 아닌 경우에만 실행될 코드
      widget.databaseProvider.insertDog(dog);
      setState(
        () {
          dogList = _getdogs();
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
          actions: <Widget>[
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
      widget.databaseProvider.updateTodo(updatedDog);
      setState(
        () {
          dogList = _getdogs();
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
          dogList = _getdogs();
        },
      );
    }
  }
}
