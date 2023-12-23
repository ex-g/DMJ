import 'package:dmj/home/home_screen.dart';
import 'package:dmj/main.dart';
import 'package:dmj/run/game/result.dart';
import 'package:dmj/run/game/reward.dart';
import 'package:dmj/run/running_screen.dart';
import 'package:dmj/wordbook/word_model.dart';
import 'package:flutter/material.dart';

class InputGame extends StatefulWidget {
  int totalTurn, nowTurn, userTurn;
  String name, wordbook, userId;
  var docs;

  InputGame(
      {super.key,
      required this.totalTurn,
      required this.nowTurn,
      required this.name,
      required this.wordbook,
      required this.docs,
      required this.userTurn,
      required this.userId});

  @override
  State<InputGame> createState() => _InputGameState();
}

class _InputGameState extends State<InputGame> {
  int _currentIndex = 0;
  List<String> answers = [];
  int rightAnswerCount = 0;
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Word> words = [];
    List<String> realAnswers = [];
    // // 화면 크기 조정
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    for (var doc in widget.docs) {
      words.add(Word(
          eng: doc.data()['eng'],
          kor: "kor",
          engSentence: "engSentence",
          korSentence: "korSentence"));

      realAnswers.add(doc.data()['kor']);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Game")),
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: height * 0.024),
              Text(
                "${_currentIndex + 1} / ${words.length}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.024),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(color: Colors.black),
              //   ),
              //   width: width * 0.024,
              //   height: height * 0.024,
              //   child: const Center(
              //       child: Text(
              //     "hi",
              //     // "hi$words-$_currentIndex-${words[_currentIndex]}-${words[_currentIndex].eng}}",
              //     // words[_currentIndex].eng,
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 46,
              //     ),
              //   )),
              // ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                width: width * 0.7,
                height: height * 0.3,
                child: Center(
                  child: Text(words[_currentIndex].eng,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 46,
                      )),
                ),
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: TextField(
                  controller: answerController,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  String answer = answerController.text;
                  if (answer == realAnswers[_currentIndex]) {
                    setState(() {
                      rightAnswerCount += 1;
                    });
                  }
                  if (_currentIndex == words.length - 1) {
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
                                  name: widget.name,
                                  userTurn: widget.userTurn,
                                )));
                  } else {
                    setState(() {
                      _currentIndex += 1;
                    });
                  }
                  answers.add(answer);
                  setState(() {
                    answerController.text = "";
                  });
                },
                child: _currentIndex == words.length - 1
                    ? const Icon(Icons.play_arrow)
                    : const Icon(Icons.check),
              )
            ],
          ),
        ),
      ),
    );
  }
}
