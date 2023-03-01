import 'package:flutter/material.dart';

class TagPage extends StatefulWidget {
  const TagPage({Key? key}) : super(key: key);

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading : false,
          title: const Text(
            "Tags",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
        ),
        body: const Center(
          child: SizedBox(
            child: Text("タグページ"),
          ),
        ));
  }
}
