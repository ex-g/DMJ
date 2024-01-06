import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class WordFlipCard extends StatelessWidget {
  String eng, kor;
  WordFlipCard({
    super.key,
    required this.eng,
    required this.kor,
  });

  @override
  Widget build(BuildContext context) {
    // 화면 크기 조정
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 0.0,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.FRONT,
        speed: 300,
        front: Container(
          width: width * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                offset: Offset(2, 2),
                blurRadius: 4,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                eng,
                style: TextStyle(
                  fontSize: eng.length > 12 ? 28 : 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        back: Container(
          width: width * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                kor,
                style: TextStyle(
                  fontSize: kor.length > 6 ? 20 : 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
