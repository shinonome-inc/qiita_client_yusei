import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading : false,
          title: const Text(
            "Settings",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
        ),
        body: const Center(
          child: SizedBox(
            child: Text("設定ページ"),
          ),
        ));
  }
}
