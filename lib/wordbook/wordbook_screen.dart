import 'package:dmj/wordbook/wordbook_card.dart';
import 'package:flutter/material.dart';

class WordbookScreen extends StatefulWidget {
  const WordbookScreen({super.key});

  @override
  State<WordbookScreen> createState() => _SecondSectionState();
}

class _SecondSectionState extends State<WordbookScreen> {
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
            const SizedBox(height: 20),
            const WordbookCard(
              name: "Basic Words",
              wordCount: "0",
              wordTotal: "500",
            ),
            const SizedBox(height: 50),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              hoverColor: Theme.of(context).cardColor,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
