import 'package:dmj/run/running_screen.dart';
import 'package:flutter/material.dart';

class LineCard extends StatelessWidget {
  final IconData icon;
  final String startStation, endStation, min, count, turn;

  const LineCard({
    super.key,
    required this.icon,
    required this.startStation,
    required this.endStation,
    required this.min,
    required this.count,
    required this.turn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RunningScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        width: 340,
        height: 120,
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      icon,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        startStation,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "-",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        endStation,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        min,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.text_fields_rounded,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        count,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.restart_alt,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        turn,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
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
                  const Icon(
                    Icons.mode_edit_outlined,
                    size: 20,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "START",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Theme.of(context).appBarTheme.backgroundColor),
                  ),
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
