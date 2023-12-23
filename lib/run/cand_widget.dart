import 'package:dmj/run/flipcard.dart';
import 'package:flutter/material.dart';

class CandWidget extends StatefulWidget {
  VoidCallback tap;
  WordFlipCard text;
  int index;
  double width;

  CandWidget({
    super.key,
    required this.tap,
    required this.text,
    required this.index,
    required this.width,
  });

  @override
  State<CandWidget> createState() => _CandWidgetState();
}

class _CandWidgetState extends State<CandWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width * 0.8,
      // height: widget.width * 0.36,
      child: InkWell(
        child: widget.text,
        onTap: () {
          setState(() {
            widget.tap();
          });
        },
      ),
    );
  }
}
