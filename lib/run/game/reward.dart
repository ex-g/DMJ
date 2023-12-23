import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/main.dart';
import 'package:dmj/run/running_screen.dart';
import 'package:flutter/material.dart';

class Reward extends StatefulWidget {
  int rightAnswerCount, totalTurn, nowTurn, userTurn;
  String name, wordbook, userId;
  Reward({
    super.key,
    required this.rightAnswerCount,
    required this.nowTurn,
    required this.totalTurn,
    required this.name,
    required this.wordbook,
    required this.userTurn,
    required this.userId,
  });

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");

  List<int> randomLst = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reward")),
      body: Column(
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
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      while (true) {
                        int random =
                            Random().nextInt(snapshot.data!.docs.length);

                        if (!randomLst.contains(random)) {
                          randomLst.add(random);
                        }

                        if (randomLst.length == 9) break;
                      }

                      return Container();
                    }
                  }))
              : Container(),
          Container(
            child: Text("${widget.rightAnswerCount}개의 박스를 개봉해주세요!"),
          ),
          FloatingActionButton(
            child: const Icon(Icons.play_arrow),
            onPressed: () {
              if (widget.nowTurn == widget.totalTurn) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RunningScreen(
                      randomList: randomLst,
                      userTurn: widget.userTurn + 1,
                      wordbook: widget.wordbook,
                      nowTurn: widget.nowTurn + 1,
                      totalTurn: widget.totalTurn,
                      name: widget.name,
                      userId: widget.userId,
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
