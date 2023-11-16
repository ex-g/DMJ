import 'package:dmj/wordbook/word_model.dart';
import 'package:flutter/material.dart';

class WordListScreen extends StatefulWidget {
  final List<Word> words;
  final String title;

  const WordListScreen({
    super.key,
    required this.words,
    required this.title,
  });

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: widget.words.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(
                  height: 4.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border.all(
                        width: 0.5,
                        // color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(
                                  widget.words[index].eng,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(
                                  widget.words[index].kor,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
