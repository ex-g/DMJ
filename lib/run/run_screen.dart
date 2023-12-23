import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/accounts/login_google.dart';
import 'package:dmj/run/run_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  TextEditingController startStationController =
      TextEditingController(text: "");
  TextEditingController endStationController = TextEditingController(text: "");
  TextEditingController lineController = TextEditingController(text: "");
  TextEditingController startCodeController = TextEditingController(text: "");
  TextEditingController endCodeController = TextEditingController(text: "");

  String line = '호선 선택';
  String startStation = '출발역';
  String endStation = '도착역';
  String wordbook = 'Basic Words';

  // Future getJson() async {
  //   String jsonString = await rootBundle.loadString('json/prac.json');
  //   final jsonResponse = json.decode(jsonString);
  //   var datas = jsonResponse["DATA"];
  //   print(datas);

  //   return datas;
  // }

  @override
  Widget build(BuildContext context) {
    final wordbooks = ['Basic Words'];
    final lineDropBox = ['호선 선택', '1호선', '2호선', '3호선'];
    String startSearchText = "";
    String endSearchText = "";
    String lineSearchText = "";

    var stations = jsonDecode('''
          [
            {"line": "3", "name": "대화", "code": "1"},
            {"line": "3", "name": "주엽", "code": "2"},
            {"line": "3", "name": "정발산", "code": "3"},
            {"line": "3", "name": "마두", "code": "4"},
            {"line": "3", "name": "백석", "code": "5"},
            {"line": "3", "name": "대곡", "code": "6"},
            {"line": "3", "name": "화정", "code": "7"},
            {"line": "3", "name": "원당", "code": "8"},
            {"line": "3", "name": "원흥", "code": "9"},
            {"line": "3", "name": "삼송", "code": "10"},
            {"line": "3", "name": "지축", "code": "11"},
            {"line": "3", "name": "구파발", "code": "12"},
            {"line": "3", "name": "연신내", "code": "13"},
            {"line": "3", "name": "불광", "code": "14"},
            {"line": "3", "name": "녹번", "code": "15"},
            {"line": "3", "name": "홍제", "code": "16"},
            {"line": "3", "name": "무악재", "code": "17"},
            {"line": "3", "name": "독립문", "code": "18"},
            {"line": "3", "name": "경복궁", "code": "19"},
            {"line": "3", "name": "안국", "code": "20"},
            {"line": "3", "name": "종로3가", "code": "21"}
          
          ]
          ''');

    List<String> stationList = [];
    List<String> lineList = [];
    List<String> codeList = [];

    for (var station in stations) {
      stationList.add(station['name']);
      lineList.add(station['line']);
      codeList.add(station['code']);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LogIn()));
          },
          child: Text(
            "RUN",
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "로그인 후 학습을 시작해보세요!",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogIn()));
                          },
                          child: const Text("로그인"),
                        ),
                      ),
                    ],
                  );
                } else {
                  var userId = snapshot.data!.uid;
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: collectionReference
                            .doc(userId)
                            .collection("runCard")
                            .orderBy("timestamp")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("-");
                          } else {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            final docs = snapshot.data!.docs;
                            return SizedBox(
                              height: 450,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(20),
                                itemCount: docs.length,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 20.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return LineCard(
                                    icon: Icons.location_on,
                                    startStation: docs[index]['startStation'],
                                    endStation: docs[index]['endStation'],
                                    count: docs[index]['count'],
                                    turn: docs[index]['turn'],
                                    wordbook: docs[index]['wordbook'],
                                    name:
                                        "${docs[index]['startStation']} - ${docs[index]['endStation']}",
                                    userId: userId,
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: collectionReference
                            .doc(userId)
                            .collection("userWordbook")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("-");
                          } else {
                            final docs = snapshot.data!.docs;

                            for (var doc in docs) {
                              if (doc.data()['count'] >= 9) {
                                wordbooks.add(doc.data()['title']);
                              }
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              return Container();
                            }
                          }
                        },
                      ),
                      FloatingActionButton(
                        onPressed: () => showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    title: Text(
                                      '새로운 경로',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // 단어장 드롭박스
                                        DropdownButton(
                                          value: wordbook,
                                          items: wordbooks.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              wordbook = value;
                                            });
                                          },
                                        ),
                                        // 호선 선택 드롭박스
                                        DropdownButton(
                                            value: line,
                                            items:
                                                lineDropBox.map((String item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (dynamic value) {
                                              setState(
                                                () {
                                                  line = value;
                                                  lineSearchText = value[0];
                                                },
                                              );
                                            }),
                                        Row(
                                          children: [
                                            // 출발역 검색
                                            Flexible(
                                              flex: 5,
                                              child: SizedBox(
                                                height: 300,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                        controller:
                                                            startStationController,
                                                        decoration:
                                                            const InputDecoration(
                                                                hintText: "출발역",
                                                                border:
                                                                    OutlineInputBorder()),
                                                        onChanged: (value) {
                                                          setState(
                                                            () {
                                                              startSearchText =
                                                                  value;
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            stationList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (startSearchText
                                                                  .isNotEmpty &&
                                                              !stationList[
                                                                      index]
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      startSearchText
                                                                          .toLowerCase())) {
                                                            return const SizedBox
                                                                .shrink();
                                                          } else if (lineSearchText
                                                                  .isNotEmpty &&
                                                              !lineList[index]
                                                                  .contains(
                                                                      lineSearchText)) {
                                                            return const SizedBox();
                                                          } else {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                startStationController
                                                                        .text =
                                                                    stationList[
                                                                        index];
                                                                startCodeController
                                                                        .text =
                                                                    codeList[
                                                                        index];
                                                              },
                                                              child: Card(
                                                                elevation: 3,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.elliptical(
                                                                            20,
                                                                            20))),
                                                                child: ListTile(
                                                                  title: Column(
                                                                    children: [
                                                                      Text(lineList[
                                                                          index]),
                                                                      Text(stationList[
                                                                          index]),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 5,
                                              child: SizedBox(
                                                height: 300,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                        controller:
                                                            endStationController,
                                                        decoration:
                                                            const InputDecoration(
                                                                hintText: "도착역",
                                                                border:
                                                                    OutlineInputBorder()),
                                                        onChanged: (value) {
                                                          setState(
                                                            () {
                                                              endSearchText =
                                                                  value;
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            stationList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (endSearchText
                                                                  .isNotEmpty &&
                                                              !stationList[
                                                                      index]
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      endSearchText
                                                                          .toLowerCase())) {
                                                            return const SizedBox
                                                                .shrink();
                                                          } else if (lineSearchText
                                                                  .isNotEmpty &&
                                                              !lineList[index]
                                                                  .contains(
                                                                      lineSearchText)) {
                                                            return const SizedBox();
                                                          } else {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                endStationController
                                                                        .text =
                                                                    stationList[
                                                                        index];
                                                                endCodeController
                                                                        .text =
                                                                    codeList[
                                                                        index];
                                                              },
                                                              child: Card(
                                                                elevation: 3,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.elliptical(
                                                                            20,
                                                                            20))),
                                                                child: ListTile(
                                                                  title: Column(
                                                                    children: [
                                                                      Text(lineList[
                                                                          index]),
                                                                      Text(stationList[
                                                                          index]),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          wordbook = "Basic Words";
                                          line = "호선 선택";
                                          lineSearchText = "";
                                          lineController.text = "";
                                          startStationController.text = "";
                                          endStationController.text = "";
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('추가'),
                                        onPressed: () {
                                          String newName =
                                              "${startStationController.text} - ${endStationController.text} - $wordbook";

                                          int count = (int.parse(
                                                      startCodeController
                                                          .text) -
                                                  int.parse(
                                                      endCodeController.text))
                                              .abs();

                                          int turn = 0;
                                          if (count <= 4) {
                                            turn = 1;
                                          } else {
                                            turn = (count / 4).floor();
                                          }
                                          setState(() {
                                            collectionReference
                                                .doc(userId)
                                                .collection("runCard")
                                                .doc(newName)
                                                .set(
                                              {
                                                "startStation":
                                                    startStationController.text,
                                                "endStation":
                                                    endStationController.text,
                                                "wordbook": wordbook,
                                                "count": "${turn * 9}개",
                                                "turn": "$turn턴",
                                                "timestamp": DateTime.now()
                                              },
                                            );
                                          });
                                          wordbook = "Basic Words";
                                          line = "호선 선택";
                                          lineSearchText = "";
                                          lineController.text = "";
                                          startStationController.text = "";
                                          endStationController.text = "";

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        hoverColor: Theme.of(context).highlightColor,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
