import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj/main.dart';
import 'package:dmj/run/cand_widget.dart';
import 'package:dmj/run/flipcard.dart';
import 'package:dmj/run/game/input_game.dart';
import 'package:dmj/run/game/match_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

// Running 모델 : 1턴에는 (3개의 러닝) + (게임)이 있음.
class Running {
  String title;
  List<WordFlipCard> words;

  Running({required this.title, required this.words});
}

class RunningScreen extends StatefulWidget {
  int nowTurn, totalTurn, basicTurn, money;
  String title, wordbook, userId;
  List<int> randomList;

  RunningScreen({
    super.key,
    required this.money,
    required this.nowTurn,
    required this.totalTurn,
    required this.title,
    required this.wordbook,
    required this.basicTurn,
    required this.userId,
    required this.randomList,
  });

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  // 파이어베이스 콜렉션 참조
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("Basic Words");
  CollectionReference<Map<String, dynamic>> collectionReference2 =
      FirebaseFirestore.instance.collection("Users");
  // 변수 설정
  int _currentIndex = 0;
  final SwiperController _controller = SwiperController();
  List<WordFlipCard> preWords = [];

  @override
  Widget build(BuildContext context) {
    // 미디어쿼리 스크린 사이즈
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    // Running 리스트 생성
    List<Running> runnings = [
      Running(title: 'metro1', words: []),
      Running(title: 'metro2', words: []),
      Running(title: 'metro3', words: []),
    ];

    // 위젯 넘겨주는 함수
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
          title: Text(
            "${widget.nowTurn}/${widget.totalTurn} Turn",
            style: const TextStyle(color: Colors.white),
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
        body: PopScope(
          canPop: false,
          child: Center(
            child: Column(
              children: [
                StreamBuilder(
                  stream: widget.wordbook == "Basic Words"
                      ? collectionReference
                          .doc("Turn${widget.basicTurn}")
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

                    // docs 만들기

                    // Basic Words라면 snapshot으로 생성
                    final docs = widget.wordbook == "Basic Words"
                        ? snapshot.data!.docs
                        : [];

                    // 나만의 단어장이라면 randomList에 있는 숫자대로 넣어줌.
                    if (widget.wordbook != "Basic Words") {
                      for (var j in widget.randomList) {
                        docs.add(snapshot.data!.docs[j]);
                      }
                    }

                    // docs 풀어서 단어 리스트 만들기
                    for (var doc in docs) {
                      var eng = doc.data()['eng'];
                      var kor = doc.data()['kor'];
                      preWords.add(WordFlipCard(eng: eng, kor: kor));
                    }

                    runnings[0].words.add(preWords[0]);
                    runnings[0].words.add(preWords[1]);
                    runnings[0].words.add(preWords[2]);
                    runnings[1].words.add(preWords[3]);
                    runnings[1].words.add(preWords[4]);
                    runnings[1].words.add(preWords[5]);
                    runnings[2].words.add(preWords[6]);
                    runnings[2].words.add(preWords[7]);
                    runnings[2].words.add(preWords[8]);

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
                            child: _currentIndex == runnings.length - 1
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // 쓰기 테스트
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InputGame(
                                                userId: widget.userId,
                                                basicTurn: widget.basicTurn,
                                                money: widget.money,
                                                docs: docs,
                                                wordbook: widget.wordbook,
                                                nowTurn: widget.nowTurn,
                                                totalTurn: widget.totalTurn,
                                                title: widget.title,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Theme.of(context)
                                                      .appBarTheme
                                                      .backgroundColor),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(120, 50)),
                                        ),
                                        child: const Text(
                                          "쓰기 테스트",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      // 매칭 테스트
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MatchGame(
                                                        userId: widget.userId,
                                                        basicTurn:
                                                            widget.basicTurn,
                                                        money: widget.money,
                                                        docs: docs,
                                                        wordbook:
                                                            widget.wordbook,
                                                        nowTurn: widget.nowTurn,
                                                        totalTurn:
                                                            widget.totalTurn,
                                                        title: widget.title,
                                                      )));
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Theme.of(context).cardColor),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(120, 50)),
                                        ),
                                        child: const Text(
                                          "매칭 테스트",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      nextFunction();
                                      setState(() {});
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Theme.of(context)
                                                    .appBarTheme
                                                    .backgroundColor),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(120, 50))),
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ),
                          ),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Container(
        //   padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
        //   child: Text(
        //     running.title,
        //     style: TextStyle(
        //       fontSize: width * 0.06,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/${running.title}.png',
          ),
        ),

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
