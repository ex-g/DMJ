import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/main.dart';
import 'package:dmj/run/game/result.dart';
import 'package:flutter/material.dart';

class InputGame extends StatefulWidget {
  int totalTurn, nowTurn, basicTurn, money;
  String title, wordbook, userId;
  var docs;

  InputGame(
      {super.key,
      required this.totalTurn,
      required this.nowTurn,
      required this.title,
      required this.money,
      required this.wordbook,
      required this.docs,
      required this.basicTurn,
      required this.userId});

  @override
  State<InputGame> createState() => _InputGameState();
}

class _InputGameState extends State<InputGame> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Users");
  // 변수 설정
  int currentIndex = 0;
  int rightAnswerCount = 0;
  Color nextColor = Colors.grey.shade400;
  String nextBtnText = '다음';
  String meaningValue = "";
  TextEditingController answerController = TextEditingController(text: "");
  // List<String> words = [
  //   'blue',
  //   'red',
  //   'yellow',
  //   'orange',
  //   'brown',
  //   'pink',
  //   'green',
  //   'purple',
  //   'white'
  // ];
  // List<String> realAnswers = [
  //   '파랑',
  //   '빨강',
  //   '노랑',
  //   '주황',
  //   '갈색',
  //   '핑크',
  //   '초록',
  //   '보라',
  //   '하양'
  // ];
  List<String> answers = [];
  List<Color> questionColor = List<Color>.filled(9, Colors.grey.shade200);

  @override
  Widget build(BuildContext context) {
    // // 화면 크기 조정
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    // // 변수 설정
    List<String> words = [];
    List<String> realAnswers = [];

    for (var doc in widget.docs) {
      words.add(doc.data()['eng']);
      realAnswers.add(doc.data()['kor']);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Game",
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(
          child: GestureDetector(
              child: const Icon(Icons.backspace_outlined),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
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
            children: [
              SizedBox(height: height * 0.02),
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
                "${currentIndex + 1} / ${words.length}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.08),
              Text(
                words[currentIndex],
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.08),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                      hintText: "뜻을 입력해주세요!", border: OutlineInputBorder()),
                  onChanged: (value) {
                    setState(() {
                      meaningValue = value;
                      meaningValue == ""
                          ? nextColor = Colors.grey
                          : currentIndex == words.length - 1
                              ? nextColor = Colors.orange
                              : nextColor = const Color(0xFF86A845);
                    });
                  },
                ),
              ),
              SizedBox(height: height * 0.048),
              ElevatedButton(
                onPressed: () {
                  if (answerController.text == "") {
                  } else {
                    String answer = answerController.text;
                    // 쓴 답이 정답이면 카운트하기
                    if (answer == realAnswers[currentIndex]) {
                      setState(() {
                        rightAnswerCount += 1;
                        questionColor[currentIndex] = Colors.lightGreen;
                      });
                    } else {
                      setState(() {
                        questionColor[currentIndex] = Colors.red.shade300;
                      });
                    }
                    if (currentIndex == words.length - 1) {
                      collectionReference
                          .doc(widget.userId)
                          .update({"basicTurn": widget.basicTurn + 1});
                      if (rightAnswerCount == 0) {
                        rightAnswerCount = 1;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Result(
                                    userId: widget.userId,
                                    wordbook: widget.wordbook,
                                    totalTurn: widget.totalTurn,
                                    nowTurn: widget.nowTurn,
                                    userAnswer: answers,
                                    realAnswer: realAnswers,
                                    words: words,
                                    count: rightAnswerCount,
                                    title: widget.title,
                                    basicTurn: widget.basicTurn + 1,
                                    money: widget.money,
                                  )));
                    } else {
                      setState(() {
                        currentIndex += 1;
                        if (currentIndex == words.length - 1) {
                          nextBtnText = "결과보기";
                        }
                      });
                    }
                    answers.add(answer);
                  }

                  // 버튼색 & 정답 컨트롤러 초기화
                  nextColor = Colors.grey.shade400;
                  answerController.text = "";
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
