import 'package:flutter/material.dart';
import 'package:music/utils/config.dart';

double letterHeight;

class AlphabetSilder extends StatelessWidget {
  AlphabetSilder(
      {@required this.onVerticalDragDown,
      @required this.onVerticalDragEnd,
      @required this.onVerticalDragCancel,
      Key key})
      : super(key: key);
  final onVerticalDragDown;
  final onVerticalDragEnd;
  final onVerticalDragCancel;
  static const List<String> alphabets = [
    '🔥',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  final List<Widget> letters = alphabets.map((String letter) {
    return Expanded(
        child: Text(
      letter,
      style: AppTextStyle.Alphabet,
    ));
  }).toList();

  // 建造可滑动的字母条索引
  Widget _buildAlphabetSilder(
      BuildContext context, BoxConstraints constraints) {
    final double _sliderHeight = constraints.biggest.height;
    letterHeight = _sliderHeight / letters.length;
    return GestureDetector(
      child: Column(
        children: letters,
      ),
      onVerticalDragDown: onVerticalDragDown,
      onVerticalDragEnd: onVerticalDragEnd,
      onVerticalDragCancel: onVerticalDragCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: _buildAlphabetSilder),
    );
  }
}
