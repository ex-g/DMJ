import 'package:dmj/wordbook/wordbook_card.dart';
import 'package:flutter/material.dart';

class WordbookScreen extends StatefulWidget {
  const WordbookScreen({super.key});

  @override
  State<WordbookScreen> createState() => _SecondSectionState();
}

class _SecondSectionState extends State<WordbookScreen> {
  final List<String> items = ["Basic Words", "My Wordbook"];
  final TextEditingController titleController = TextEditingController();

  Future<void> addItemEvent(BuildContext context) {
    // 다이얼로그 폼 열기
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              '새 단어장 만들기',
              style: TextStyle(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: '단어장 이름',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('추가'),
                onPressed: () {
                  setState(() {
                    String newName = titleController.text;
                    // String content = contentController.text;
                    items.add(newName);
                    // itemContents.add(content);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "WORDBOOK",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(
                  height: 20.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return WordbookCard(
                    name: items[index],
                  );
                },
              ),
            ),
            // const WordbookCard(
            //   name: "Basic Words",
            // ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () => addItemEvent(context),
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              hoverColor: Theme.of(context).cardColor,
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
