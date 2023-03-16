import 'package:flutter/material.dart';

import '../view_model/tag_view_model.dart';

class TagDetailListPage extends StatelessWidget {
  final Tag tag;

  const TagDetailListPage({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tag.name),
      ),
      body: const Center(
        child: Text('タグ詳細ページ'),
      ),
    );
  }
}
