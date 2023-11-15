import 'package:dmj/wordbook/word_list_screen.dart';
import 'package:dmj/wordbook/word_model.dart';
import 'package:flutter/material.dart';

class WordbookCard extends StatefulWidget {
  final String name, wordCount, wordTotal;

  const WordbookCard({
    super.key,
    required this.name,
    required this.wordCount,
    required this.wordTotal,
  });

  @override
  State<WordbookCard> createState() => _WordbookCardState();
}

class _WordbookCardState extends State<WordbookCard> {
  List<Word> words = [
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
    Word.fromMap({
      'eng': 'orange',
      'kor': '오렌지',
      'engSentence': 'Orange is good.',
      'korSentence': '오렌지는 좋다.'
    }),
    Word.fromMap({
      'eng': 'pineapple',
      'kor': '파인애플',
      'engSentence': 'Pineappple is good.',
      'korSentence': '파인애플은 좋다.'
    }),
    Word.fromMap({
      'eng': 'pear',
      'kor': '배',
      'engSentence': 'Pear is good.',
      'korSentence': '배는 좋다.'
    }),
    Word.fromMap({
      'eng': 'strawberry',
      'kor': '딸기',
      'engSentence': 'Strawberry is good.',
      'korSentence': '딸기는 좋다.'
    }),
    Word.fromMap({
      'eng': 'melon',
      'kor': '멜론',
      'engSentence': 'Melon is good.',
      'korSentence': '멜론은 좋다.'
    }),
    Word.fromMap({
      'eng': 'peach',
      'kor': '복숭아',
      'engSentence': 'Peach is good.',
      'korSentence': '복숭아는 좋다.'
    }),
  ];

  void justFunction() {
    String newName = "hi";
    print(newName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WordListScreen(words: words, title: widget.name)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                offset: Offset(2, 2),
                blurRadius: 4,
              )
            ]),
        width: 340,
        height: 100,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Flexible(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.text_fields_sharp,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.wordCount,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Text("/"),
                      Text(
                        "${words.length}",
                        style: const TextStyle(fontSize: 12),
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
                  IconButton(
                    onPressed: justFunction,
                    icon:
                        const Icon(Icons.mode_edit_outline_outlined, size: 20),
                  ),
                  const SizedBox(height: 35),
                  // Text(
                  //   "QUIZ",
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w700,
                  //       color: Theme.of(context).appBarTheme.backgroundColor),
                  // ),
                  const SizedBox(height: 15),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
