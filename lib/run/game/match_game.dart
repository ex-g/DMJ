import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/main.dart';
import 'package:dmj/run/game/result.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// Question 클래스
class Question {
  late String eng;
  late String kor;
  late bool isAnswer;

  Question(String eng, String kor, bool isAnswer) {
    this.eng = eng;
    this.kor = kor;
    this.isAnswer = isAnswer;
  }
}

class MatchGame extends StatefulWidget {
  int totalTurn, nowTurn, basicTurn, money;
  String title, wordbook, userId;
  var docs;

  MatchGame(
      {super.key,
      required this.totalTurn,
      required this.nowTurn,
      required this.title,
      required this.wordbook,
      required this.docs,
      required this.basicTurn,
      required this.money,
      required this.userId});

  @override
  State<MatchGame> createState() => _MatchGameState();
}

// int incorrectCnt = 9 - correctCnt;
makeQRandom(index) {
  var lst = [];
  while (lst.length != 4) {
    int ran = Random().nextInt(9);
    if (ran != index && !lst.contains(ran)) {
      lst.add(ran);
    }
  }
  return lst;
}

class _MatchGameState extends State<MatchGame> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");

  // 변수 설정
  int correctCnt = 0;
  int _currentIndex = 0;
  String nextBtnText = "다음";
  Color bgColor = Colors.white;
  Color nextColor = Colors.grey.shade400;
  List<bool> isSolved = List.filled(9, false);
  // List<String> incorrectList = [];
  List<Color> btnColors = [
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue,
  ];
  List<String> userAnswer = [];

  List<Color> questionColor = List<Color>.filled(9, Colors.grey.shade200);
  // 퀴즈의 답이 올 위치
  Map randomList = {
    0: Random().nextInt(4),
    1: Random().nextInt(4),
    2: Random().nextInt(4),
    3: Random().nextInt(4),
    4: Random().nextInt(4),
    5: Random().nextInt(4),
    6: Random().nextInt(4),
    7: Random().nextInt(4),
    8: Random().nextInt(4),
  };
  // 어떤 게 정답 대상들로 나올지 랜덤으로 뽑음
  Map Q = {
    0: makeQRandom(0),
    1: makeQRandom(1),
    2: makeQRandom(2),
    3: makeQRandom(3),
    4: makeQRandom(4),
    5: makeQRandom(5),
    6: makeQRandom(6),
    7: makeQRandom(7),
    8: makeQRandom(8),
  };

  @override
  Widget build(BuildContext context) {
    List<String> words = [];
    List<String> realAnswers = [];

    for (var doc in widget.docs) {
      words.add(doc.data()['eng']);
      realAnswers.add(doc.data()['kor']);
    }

    List questions = [];
    for (var q in Q[_currentIndex]) {
      questions.add(realAnswers[q]);
    }
    questions[randomList[_currentIndex]] = realAnswers[_currentIndex];

    // 사용자가 카드 골랐을 때
    onClickCard(int cardNum) {
      setState(() {
        isSolved[_currentIndex] = true;
        userAnswer.add(questions[cardNum]);
        // 버튼 관련
        if (_currentIndex < 8) {
          nextColor = const Color(0xFF86A845);
        } else {
          nextBtnText = "결과보기";
          nextColor = Colors.amber.shade700;
        }

        // 정답 대상 한글 박스 색깔 입히기
        for (int i = 0; i < 4; i++) {
          if (i == randomList[_currentIndex]) {
            btnColors[i] = Colors.lightGreen;
          } else {
            btnColors[i] = Colors.red.shade300;
          }
        }

        // 사용자 정답 여부 확인
        if (cardNum == randomList[_currentIndex]) {
          bgColor = Colors.lightGreen.shade200;
          questionColor[_currentIndex] = Colors.lightGreen;
          correctCnt++;
        } else {
          bgColor = const Color.fromARGB(255, 255, 218, 222);
          questionColor[_currentIndex] = Colors.red.shade300;
        }
      });
    }

    // 반복코드 : 정답체크박스 만들기
    makeAnsCheckBox(qColor) {
      return Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: questionColor[qColor],
          borderRadius: BorderRadius.circular(7),
        ),
      );
    }

    // 반복코드 : 뜻 한글 띄우기
    makeAnsContainer(number) {
      return ElevatedButton(
        onPressed: () {
          if (!isSolved[_currentIndex]) {
            onClickCard(number);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(btnColors[number]),
          minimumSize: MaterialStateProperty.all(const Size(160, 60)),
        ),
        child: Text(
          questions[number],
          style: TextStyle(
            fontSize: questions[number].toString().length > 6 ? 15 : 24,
            color: Colors.white,
          ),
        ),
      );
    }

    // 미디어쿼리
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "매칭게임",
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(
          child: GestureDetector(
              child: const Icon(
                Icons.backspace_outlined,
                color: Colors.white,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          title: Text(
                            '단어 학습을 중단하시겠습니까?',
                            style: TextStyle(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
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
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage()));
                              },
                            ),
                            TextButton(
                              child: const Text('아니오'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                    });
              }),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: height * 0.02),

              // 정답 체크 네모박스 9개
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  makeAnsCheckBox(0),
                  makeAnsCheckBox(1),
                  makeAnsCheckBox(2),
                  makeAnsCheckBox(3),
                  makeAnsCheckBox(4),
                  makeAnsCheckBox(5),
                  makeAnsCheckBox(6),
                  makeAnsCheckBox(7),
                  makeAnsCheckBox(8),
                ],
              ),
              SizedBox(height: height * 0.02),
              Text(
                "${_currentIndex + 1} / ${words.length}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.15),
              Text(
                words[_currentIndex],
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      makeAnsContainer(0),
                      const SizedBox(width: 10),
                      makeAnsContainer(1),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      makeAnsContainer(2),
                      const SizedBox(width: 10),
                      makeAnsContainer(3),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
              ElevatedButton(
                onPressed: () {
                  if (_currentIndex == words.length - 1) {
                    // 마지막 단어일 때
                    collectionReference2
                        .doc(widget.userId)
                        .update({"basicTurn": widget.basicTurn + 1});
                    if (correctCnt == 0) {
                      correctCnt = 1;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Result(
                                userAnswer: userAnswer,
                                realAnswer: realAnswers,
                                words: words,
                                count: correctCnt,
                                nowTurn: widget.nowTurn,
                                totalTurn: widget.totalTurn,
                                title: widget.title,
                                wordbook: widget.wordbook,
                                basicTurn: widget.basicTurn + 1,
                                money: widget.money,
                                userId: widget.userId)));
                  } else {
                    // 마지막 단어 아니고 사용자가 정답 체크 했을 때
                    setState(() {
                      if (isSolved[_currentIndex] != false) {
                        _currentIndex += 1;
                      }
                    });
                  }
                  // 배경색 & 버튼 색깔 & 답 선지 초기화
                  bgColor = Colors.white;
                  nextColor = Colors.grey.shade400;
                  btnColors = [
                    Colors.blue,
                    Colors.blue,
                    Colors.blue,
                    Colors.blue,
                  ];
                  questions = ["다른답1", "다른답2", "다른답3", "다른답4"];
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(nextColor),
                  minimumSize: MaterialStateProperty.all(const Size(120, 50)),
                ),
                child: Text(
                  nextBtnText,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
