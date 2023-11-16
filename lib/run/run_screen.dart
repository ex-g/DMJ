import 'package:dmj/run/run_card.dart';
import 'package:flutter/material.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  Future<void> addItemEvent(BuildContext context) {
    // 다이얼로그 폼 열기
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            '단무지 카드 만들기',
            style: TextStyle(
                color: Theme.of(context).appBarTheme.backgroundColor,
                fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                // controller: titleController,
                decoration: InputDecoration(
                  labelText: '출발역',
                ),
              ),
              TextField(
                // controller: contentController,
                decoration: InputDecoration(
                  labelText: '도착역',
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
                // setState(() {
                //   String title = titleController.text;
                //   String content = contentController.text;
                //   items.add(title);
                //   itemContents.add(content);
                // });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "RUN",
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const LineCard(
              icon: Icons.circle_notifications,
              startStation: "종로3가",
              endStation: "외대앞",
              min: "10min",
              count: "100개",
              turn: "4턴",
            ),
            // const SizedBox(height: 20),
            // const LineCard(
            //   icon: Icons.flag_circle_sharp,
            //   startStation: "원당",
            //   endStation: "종로3가",
            //   min: "30min",
            //   count: "100개",
            //   turn: "3턴",
            // ),
            const SizedBox(height: 40),
            FloatingActionButton(
              onPressed: () => addItemEvent(context)
              // context: context,
              // builder: (context) {
              //   return SimpleDialog(
              //     title: const Text("다크 모드로 변경하시겠습니까?"),
              //     children: [
              //       TextButton(
              //         child: const Text("예"),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       ),
              //       TextButton(
              //         child: const Text("아니오"),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       ),
              //     ],
              //   );
              // });
              ,
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
