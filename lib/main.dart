import 'package:flutter/material.dart';
import 'package:flutter_app/screens/top_page.dart';
import 'package:connectivity/connectivity.dart';

//ネットワークの疎通状況
bool interNetConnected = true;

//ネットワークの疎通確認
Future<bool> checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  interNetConnected = await checkConnectivity();
  runApp(const AppBarApp());
}

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
