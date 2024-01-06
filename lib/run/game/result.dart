import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/run/game/coin_check.dart';
import 'package:dmj/run/game/coin_select.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Result extends StatefulWidget {
  List<String> userAnswer, realAnswer, words;
  int count, nowTurn, totalTurn, basicTurn, money;
  String title, wordbook, userId;

  Result(
      {super.key,
      required this.userAnswer,
      required this.realAnswer,
      required this.words,
      required this.count,
      required this.nowTurn,
      required this.totalTurn,
      required this.title,
      required this.wordbook,
      required this.basicTurn,
      required this.money,
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
      appBar: AppBar(
        title: const Text(
          "Result",
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(),
      ),
      body: PopScope(
        canPop: false,
        child: Column(
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("맞힌 갯수 : ${widget.count}"),
                    SizedBox(width: width * 0.048),
                    FloatingActionButton(
                      backgroundColor: const Color(0xFF86A845),
                      child: const Icon(Icons.lock_open),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoinSelect(
                              basicTurn: widget.basicTurn,
                              money: widget.money,
                              wordbook: widget.wordbook,
                              title: widget.title,
                              totalTurn: widget.totalTurn,
                              nowTurn: widget.nowTurn,
                              rightAnswerCount: widget.count,
                              userId: widget.userId,
                              count: widget.count,
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
      ),
    );
  }

  DataRow makeDataRow(int index) {
    return DataRow(
      cells: [
        DataCell(Center(
            child: Text(
          widget.words[index],
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
