import 'package:flutter/material.dart';
import 'package:flutter_app/screens/top_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/connection_status.dart';

// インスタンスへの参照を取得
final connectionStatus = ConnectionStatus();

// Qiita APIのアクセストークン
// アクセストークンを保持するグローバル変数
String? accessToken;

// SharedPreferences インスタンスを作成する
Future<SharedPreferences> getPrefs() async {
  return await SharedPreferences.getInstance();
}

// アクセストークンを保存する関数
Future<void>saveAccessToken(String token) async {
  final prefs = await getPrefs();
  prefs.setString('accessToken', token);
  accessToken = token;
  print("取得したアクセストークン：$accessToken");
}

// アクセストークンを読み込む関数
Future<void> loadAccessToken() async {
  final prefs = await getPrefs();
  accessToken = prefs.getString('accessToken');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  connectionStatus.interNetConnected = await ConnectionStatus.checkConnectivity();
  await loadAccessToken();
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
