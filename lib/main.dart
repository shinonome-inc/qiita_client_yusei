import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/top_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/connection_status.dart';

// インスタンスへの参照を取得
final connectionStatus = ConnectionStatus();

// Qiita APIのアクセストークン
// アクセストークンを保持するグローバル変数
late String accessToken;

// SharedPreferences インスタンスを作成する
Future<SharedPreferences> getPrefs() async {
  return await SharedPreferences.getInstance();
}

// アクセストークンを保存する関数
Future<void> saveAccessToken(String token) async {
  final prefs = await getPrefs();
  prefs.setString('qiita_auth', token);
  accessToken = token;
  if (accessToken == '') {
    print("アクセストークン：$accessToken →空になりました");
  }
  print("取得したアクセストークン：$accessToken");
}

// アクセストークンを読み込む関数
Future<void> loadAccessToken() async {
  final prefs = await getPrefs();
  if (prefs.getString('qiita_auth') == null) {
    //初めて起動する端末はaccessTokenがnullなので、空文字を代入
    await saveAccessToken('');
    print("初期起動なので、ローカルのアクセストークンに空文字を設定");
  }
  print("ローカルに保存されているトークン→'${prefs.getString('qiita_auth')}'");
  //アクセストークンの初期化
  accessToken = prefs.getString('qiita_auth')!;
  print("アクセストークン（'$accessToken'）をグローバル変数に設定しました");
}

// アクセストークンを削除する関数
Future<void> deleteAccessToken() async {
  final prefs = await getPrefs();
  await prefs.remove('qiita_auth');
  saveAccessToken('');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  connectionStatus.interNetConnected =
      await ConnectionStatus.checkConnectivity();
  await loadAccessToken();
  if (accessToken.isNotEmpty) {
    print("アクセストークンが設定されているので、Feed画面に遷移します");
  } else {
    print("アクセストークンが空文字です。Top画面に遷移します");
  }
  runApp(const AppBarApp());
}

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (accessToken.isNotEmpty) {
      //アクセストークンがある時はホームページに遷移
      home = const HomePage();
    } else {
      home = const TopPage();
    }
    return MaterialApp(title: 'Qiita client yusei', home: home);
  }
}
