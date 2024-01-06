import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/run/game/coin_check.dart';
import 'package:flutter/material.dart';

class CoinSelect extends StatefulWidget {
  int rightAnswerCount, totalTurn, nowTurn, basicTurn, money, count;
  String title, wordbook, userId;
  CoinSelect(
      {super.key,
      required this.rightAnswerCount,
      required this.nowTurn,
      required this.totalTurn,
      required this.title,
      required this.wordbook,
      required this.basicTurn,
      required this.money,
      required this.userId,
      required this.count});

  @override
  State<CoinSelect> createState() => _CoinSelectState();
}

class _CoinSelectState extends State<CoinSelect> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");
  // 변수 설정
  int coinSum = 0;
  int cnt = 0;
  String addr = 'assets/images/card.png';
  Map<int, int> coinList = {
    0: (Random().nextInt(10) + 1) * 10,
    1: Random().nextInt(10) * 10,
    2: Random().nextInt(10) * 10,
    3: Random().nextInt(10) * 10,
    4: Random().nextInt(10) * 10,
    5: Random().nextInt(10) * 10,
    6: Random().nextInt(10) * 10,
    7: Random().nextInt(10) * 10,
    8: Random().nextInt(10) * 10,
    9: Random().nextInt(10) * 10,
    10: Random().nextInt(10) * 10,
    11: Random().nextInt(10) * 10,
  };
  List<bool> visiblityList = List.filled(12, true);
  void _hide(cardNum) {
    setState(() {
      visiblityList[cardNum] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 미디어쿼리 스크린사이즈
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    makeCard(cardNum) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: width * 0.15,
              height: width * 0.2,
              child: Center(
                  child: Text(
                "${coinList[cardNum]}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF86A845)),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  _hide(cardNum);
                  var val = coinList[cardNum];
                  coinSum = coinSum + val!;
                  money = coinSum + val;
                  cnt++;
                  // n장의 카드를 다 뽑으면
                  if (cnt == widget.count) {
                    collectionReference
                        .doc(widget.userId)
                        .update({"money": widget.money + coinSum});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoinCheck(
                            coinSum: coinSum,
                            nowTurn: widget.nowTurn,
                            totalTurn: widget.totalTurn,
                            title: widget.title,
                            wordbook: widget.wordbook,
                            basicTurn: widget.basicTurn,
                            money: widget.money + coinSum,
                            userId: widget.userId),
                      ),
                    );
                  }
                },
              );
            },
            child: Visibility(
              visible: visiblityList[cardNum],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  addr,
                  width: width * 0.15,
                  height: width * 0.2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    makeCardRow(cardNumList) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            makeCard(cardNumList[0]),
            makeCard(cardNumList[1]),
            makeCard(cardNumList[2])
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Reward",
            style: TextStyle(color: Colors.white),
          ),
          leading: Container(),
        ),
        body: PopScope(
          canPop: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "${widget.count}개의 카드를 선택해주세요!",
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                makeCardRow([0, 1, 2]),
                makeCardRow([3, 4, 5]),
                makeCardRow([6, 7, 8]),
                makeCardRow([9, 10, 11]),
              ],
            ),
          ),
        ));
  }
}
