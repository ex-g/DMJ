import 'package:flutter/material.dart';

class StaticCard extends StatelessWidget {
  String wordCount, time;
  StaticCard({
    super.key,
    required this.wordCount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(20)),
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.text_fields,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    wordCount,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.timer,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
