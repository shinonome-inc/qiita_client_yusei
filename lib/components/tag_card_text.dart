import 'package:flutter/material.dart';
import '../model/tag.dart';

class TagCardText extends StatelessWidget {
  final String label;
  final Tag tag;

  const TagCardText({Key? key, required this.label, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      fontFamily: 'Noto Sans JP',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1,
      letterSpacing: 0,
      color: Color(0xFF828282),
    );

    return Text(
      '$label${label == '記事件数：' ? tag.itemsCount : tag.followersCount}',
      style: style,
      textAlign: TextAlign.center,
    );
  }
}
