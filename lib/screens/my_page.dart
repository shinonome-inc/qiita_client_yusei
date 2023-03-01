import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading : false,
          title: const Text(
            "MyPage",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
        ),
        body: const Center(
          child: SizedBox(
            child: Text("マイページ"),
          ),
        ));
  }
}
