import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/main.dart';
import 'package:dmj/run/cand_widget.dart';
import 'package:dmj/run/flipcard.dart';
import 'package:dmj/run/game/input_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

// StatefulWidget
class RunningScreen extends StatefulWidget {
  int nowTurn, totalTurn, userTurn;
  String name, wordbook, userId;
  List<int> randomList;

  RunningScreen({
    super.key,
    required this.nowTurn,
    required this.totalTurn,
    required this.name,
    required this.wordbook,
    required this.userTurn,
    required this.userId,
    required this.randomList,
  });

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

// Running 모델 : 1턴에는 (3개의 러닝) + (게임)이 있음.
class Running {
  String title;
  List<WordFlipCard> words;

  Running({required this.title, required this.words});
}

class _RunningScreenState extends State<RunningScreen> {
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");

  int _currentIndex = 0;
  final SwiperController _controller = SwiperController();
  List<WordFlipCard> words2 = [];

  @override
  Widget build(BuildContext context) {
    // // 화면 크기 조정
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    // // Running 리스트
    List<Running> runnings = [
      Running(title: 'station1', words: []),
      Running(title: 'station2', words: []),
      Running(title: 'station3', words: []),
    ];

    // // 위젯 넘겨주는 함수
    void nextFunction() {
      if (_currentIndex == runnings.length - 1) {
      } else {
        _currentIndex += 1;
        _controller.next();
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.nowTurn}/${widget.totalTurn} Turn"),
          leading: Container(
            child: GestureDetector(
                child: const Icon(Icons.backspace_outlined),
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
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            children: [
              StreamBuilder(
                stream: widget.wordbook == "Basic Words"
                    ? collectionReference
                        .doc("Turn${widget.userTurn}")
                        .collection("Words")
                        .snapshots()
                    : collectionReference2
                        .doc(widget.userId)
                        .collection("userWordbook")
                        .doc(widget.wordbook)
                        .collection("Words")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final docs = widget.wordbook == "Basic Words"
                      ? snapshot.data!.docs
                      : [];

                  if (widget.wordbook != "Basic Words") {
                    for (var j in widget.randomList) {
                      docs.add(snapshot.data!.docs[j]);
                    }
                  }

                  for (var doc in docs) {
                    var eng = doc.data()['eng'];
                    var kor = doc.data()['kor'];
                    var engSentence = "engSentence";
                    var korSentence = "korSentence";
                    words2.add(WordFlipCard(
                        eng: eng,
                        kor: kor,
                        engSentence: engSentence,
                        korSentence: korSentence));
                  }

                  runnings[0].words.add(words2[0]);
                  runnings[0].words.add(words2[1]);
                  runnings[0].words.add(words2[2]);
                  runnings[1].words.add(words2[3]);
                  runnings[1].words.add(words2[4]);
                  runnings[1].words.add(words2[5]);
                  runnings[2].words.add(words2[6]);
                  runnings[2].words.add(words2[7]);
                  runnings[2].words.add(words2[8]);

                  return Column(
                    children: [
                      SizedBox(
                        width: width * 0.75,
                        height: height * 0.8,
                        child: Swiper(
                          itemCount: runnings.length,
                          controller: _controller,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildQuizCard(runnings[_currentIndex],
                                width, height, context);
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(width * 0.012),
                        child: Center(
                            child: FloatingActionButton(
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          hoverColor: Theme.of(context).highlightColor,
                          onPressed: () {
                            nextFunction();
                            setState(() {});
                          },
                          child: _currentIndex == runnings.length - 1
                              ? GestureDetector(
                                  child: const Icon(Icons.gamepad),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InputGame(
                                                  userId: widget.userId,
                                                  userTurn: widget.userTurn,
                                                  docs: docs,
                                                  wordbook: widget.wordbook,
                                                  nowTurn: widget.nowTurn,
                                                  totalTurn: widget.totalTurn,
                                                  name: widget.name,
                                                )));
                                  },
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                ),
                        )),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildQuizCard(
    Running running, double width, double height, BuildContext context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
          child: Text(
            running.title,
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Container()),
        Column(children: _buildCandidates(width, running)),
      ],
    ),
  );
}

List<Widget> _buildCandidates(double width, Running running) {
  List<Widget> children = [];
  for (int i = 0; i < 3; i++) {
    children.add(
      CandWidget(
        index: i,
        text: running.words[i],
        width: width,
        tap: () {},
      ),
    );
    children.add(
      Padding(
        padding: EdgeInsets.all(width * 0.024),
      ),
    );
  }
  return children;
}
