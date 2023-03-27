import 'package:flutter/material.dart';
import 'package:flutter_app/screens/top_page.dart';
import '../util/connection_status.dart';

// インスタンスへの参照を取得
final connectionStatus = ConnectionStatus();

// Qiita APIのアクセストークン
late String accessToken;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  connectionStatus.interNetConnected = await ConnectionStatus.checkConnectivity();
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
