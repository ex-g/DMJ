import 'package:dmj/run/flipcard.dart';
import 'package:dmj/wordbook/word_model.dart';
import 'package:flutter/material.dart';

class RunningScreen extends StatefulWidget {
  final List<Word> words = [
    Word.fromMap({
      'eng': 'apple',
      'kor': '사과',
      'engSentence': 'Apple is good.',
      'korSentence': '사과는 좋다.'
    }),
    Word.fromMap({
      'eng': 'banana',
      'kor': '바나나',
      'engSentence': 'Banana is good.',
      'korSentence': '바나나는 좋다.'
    }),
    Word.fromMap({
      'eng': 'grape',
      'kor': '포도',
      'engSentence': 'Grpae is good.',
      'korSentence': '포도는 좋다.'
    }),
  ];

  RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  int index = 0;

  void nextFunction() {
    if (index == widget.words.length - 1) {
    } else {
      index += 1;
    }
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    // var index = 1;
    // WordFlipCard flip = WordFlipCard(
    //   eng: widget.words[index].eng,
    //   kor: widget.words[index].kor,
    //   engSentence: widget.words[index].engSentence,
    //   korSentence: widget.words[index].korSentence,
    // );

    Widget makeFlip(index) {
      return WordFlipCard(
        eng: widget.words[index].eng,
        kor: widget.words[index].kor,
        engSentence: widget.words[index].engSentence,
        korSentence: widget.words[index].korSentence,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Running")),
      backgroundColor: Theme.of(context).cardColor,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            makeFlip(0),
            makeFlip(1),
            makeFlip(2),
            const SizedBox(height: 20),
            // 위로 슬라이딩 하면 없어지는 거 어떻게 해야할지 모르겠다... ㅜ
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              hoverColor: Theme.of(context).cardColor,
              child: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
