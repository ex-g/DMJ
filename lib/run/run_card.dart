import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/run/flipcard.dart';
import 'package:dmj/run/running_screen.dart';
import 'package:flutter/material.dart';

class LineCard extends StatefulWidget {
  final IconData icon;
  int money, basicTurn;
  final String startStation, endStation, count, turn, wordbook, title, userId;

  LineCard({
    super.key,
    required this.icon,
    required this.money,
    required this.basicTurn,
    required this.startStation,
    required this.endStation,
    required this.count,
    required this.turn,
    required this.wordbook,
    required this.title,
    required this.userId,
  });

  @override
  State<LineCard> createState() => _LineCardState();
}

class _LineCardState extends State<LineCard> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  List<WordFlipCard> words = [];
  List<int> randomLst = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.wordbook != "Basic Words"
            ? StreamBuilder(
                stream: collectionReference
                    .doc(widget.userId)
                    .collection("userWordbook")
                    .doc(widget.wordbook)
                    .collection("Words")
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("-");
                  } else {
                    while (true) {
                      int random = Random().nextInt(snapshot.data!.docs.length);
                      // 랜덤리스트에 이미 없을 때만 추가
                      if (!randomLst.contains(random)) {
                        randomLst.add(random);
                      }
                      // 9개가 되면 끝
                      if (randomLst.length == 9) break;
                    }
                  }

                  return Container();
                }))
            : Container(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RunningScreen(
                    randomList:
                        widget.wordbook == "Basic Words" ? [] : randomLst,
                    userId: widget.userId,
                    basicTurn: widget.basicTurn,
                    wordbook: widget.wordbook,
                    title: widget.title,
                    nowTurn: 1,
                    totalTurn: int.parse(widget.turn[0]),
                    money: widget.money),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            width: 340,
            height: 120,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          widget.icon,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text(
                            widget.startStation,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.arrow_back, size: 10),
                          const Icon(Icons.arrow_forward, size: 10),
                          const SizedBox(width: 5),
                          Text(
                            widget.endStation,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(
                            Icons.book,
                            size: 12,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.wordbook,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const Text(
                            " - ",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.count,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.restart_alt,
                            size: 12,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.turn,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        title: Text(
                                          '경로 카드를 삭제하시겠습니까?',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .appBarTheme
                                                .backgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('예'),
                                            onPressed: () {
                                              setState(() {
                                                // 경로 카드 삭제
                                                collectionReference
                                                    .doc(widget.userId)
                                                    .collection("runCard")
                                                    .doc(
                                                        "${widget.startStation} - ${widget.endStation} - ${widget.wordbook}")
                                                    .delete();
                                              });

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('아니오'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ));
                            },
                            icon: const Icon(Icons.delete, size: 20),
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "START",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
