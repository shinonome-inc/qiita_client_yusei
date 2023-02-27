import 'package:flutter/material.dart';
import 'package:flutter_app/screens/top_page.dart';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Qiita client yusei',
      home: TopPage(),
    );
  }
}
