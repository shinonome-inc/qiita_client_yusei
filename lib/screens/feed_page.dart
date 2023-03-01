import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading : false,
          title : const Text("Feed",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),

        ),
        body : const Center(
          child: SizedBox(
            child: Text("フィードページ"),
          ),
        )
    );
  }
}
