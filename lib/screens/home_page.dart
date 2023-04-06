import 'package:flutter/material.dart';
import 'package:flutter_app/screens/feed_page.dart';
import 'package:flutter_app/screens/tag_page.dart';
import 'package:flutter_app/screens/my_page.dart';
import 'package:flutter_app/screens/setting_page.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> display = [
    const FeedPage(),
    const TagPage(),
    const MyPage(),
    const SettingPage(),
  ];

  var _currentIndex = 0;
  String? _title;
  var _color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _color = Colors.transparent;
    _title = 'Feed';
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;

      switch (index) {
        case 0:
          _title = 'Feed';
          _color = Colors.transparent;
          break;
        case 1:
          _title = 'Tags';
          _color = Colors.white.withOpacity(0.3);
          break;
        case 2:
          _title = 'MyPage';
          _color = Colors.white.withOpacity(0.3);
          break;
        case 3:
          _title = 'Settings';
          _color = Colors.white.withOpacity(0.3);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: !connectionStatus.interNetConnected
            ? AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white.withOpacity(0.3),
          automaticallyImplyLeading: false,
          title: null,
          // toolbarHeight: 0,
        )
            : AppBar(
          backgroundColor: Colors.white,
          shadowColor: _color,
          automaticallyImplyLeading: false,
          title: _title != ''
              ? Text(
            _title!,
            style: const TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 17.0,
              color: Colors.black,
            ),
          )
              : null,
          centerTitle: true,
          toolbarHeight: 70,
        ),
        body: display[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: const Color(0x00000000).withOpacity(0.3),
                ),
              )),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted_outlined),
                label: 'フィード',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.label_outline),
                label: 'タグ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'マイページ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: '設定',
              ),
            ],
            currentIndex: _currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: const Color(0xFF828282),
            selectedItemColor: const Color(0xFF74C13A),
            unselectedFontSize: 10,
            selectedFontSize: 10,
          ),
        ),
      ),
    );
  }
}

