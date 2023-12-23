import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/run/game/reward.dart';
import 'package:dmj/wordbook/word_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Result extends StatefulWidget {
  List<String> userAnswer;
  List<String> realAnswer;
  List<Word> words;
  int count, nowTurn, totalTurn, userTurn;
  String name, wordbook, userId;

  Result(
      {super.key,
      required this.userAnswer,
      required this.realAnswer,
      required this.words,
      required this.count,
      required this.nowTurn,
      required this.totalTurn,
      required this.name,
      required this.wordbook,
      required this.userTurn,
      required this.userId});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("Users");
    // // 화면 크기 조정
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    var dateFormatter = DateFormat('yyMMdd');
    var now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Column(
        children: [
          StreamBuilder(
            stream: collectionReference
                .doc(widget.userId)
                .collection("dayStamp")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("데이터 없음");
              } else {
                final docs = snapshot.data!.docs;
                if (docs.last.data()['date'] != dateFormatter.format(now)) {
                  var newDate = dateFormatter.format(now);
                  var year = int.parse(DateFormat('yyyy').format(now));
                  var month = int.parse(DateFormat('MM').format(now));
                  var day = int.parse(DateFormat('dd').format(now));

                  collectionReference
                      .doc(widget.userId)
                      .collection("dayStamp")
                      .doc(newDate)
                      .set({
                    "date": newDate,
                    "year": year,
                    "month": month,
                    "day": day,
                  });

                  return const Text("");
                } else {
                  return Container();
                }
              }
            },
          ),
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('영어')),
                    DataColumn(label: Text('제출')),
                    DataColumn(label: Text('정답')),
                    DataColumn(label: Text('결과')),
                  ],
                  rows: [
                    makeDataRow(0),
                    makeDataRow(1),
                    makeDataRow(2),
                    makeDataRow(3),
                    makeDataRow(4),
                    makeDataRow(5),
                    makeDataRow(6),
                    makeDataRow(7),
                    makeDataRow(8),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("맞힌 갯수 : ${widget.count}"),
                  SizedBox(width: width * 0.048),
                  FloatingActionButton(
                    child: const Icon(Icons.lock_open),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Reward(
                            userTurn: widget.userTurn,
                            wordbook: widget.wordbook,
                            name: widget.name,
                            totalTurn: widget.totalTurn,
                            nowTurn: widget.nowTurn,
                            rightAnswerCount: widget.count,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  DataRow makeDataRow(int index) {
    return DataRow(
      cells: [
        DataCell(Center(
            child: Text(
          widget.words[index].eng,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ))),
        DataCell(Center(child: Text(widget.userAnswer[index]))),
        DataCell(Center(
            child: Text(widget.realAnswer[index],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)))),
        DataCell(widget.userAnswer[index] == widget.realAnswer[index]
            ? Center(
                child: Text(
                  "O",
                  style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Center(
                child: Text(
                  "X",
                  style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ))
      ],
    );
  }
}
