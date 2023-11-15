import 'package:dmj/run/run_card.dart';
import 'package:flutter/material.dart';

class RunScreen extends StatelessWidget {
  const RunScreen({super.key});

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
            const SizedBox(height: 20),
            const LineCard(
              icon: Icons.flag_circle_sharp,
              startStation: "원당",
              endStation: "종로3가",
              min: "30min",
              count: "100개",
              turn: "3턴",
            ),
            const SizedBox(height: 40),
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
