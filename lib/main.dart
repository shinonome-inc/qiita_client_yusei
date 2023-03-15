import 'package:flutter/material.dart';
import 'package:flutter_app/screens/top_page.dart';
import 'package:connectivity/connectivity.dart';


class ConnectionStatus {
  late bool interNetConnected;

  // クラス内で唯一のインスタンスを保持するための静的変数を宣言する
  static final ConnectionStatus _instance = ConnectionStatus._internal();

  // 唯一のインスタンスにアクセスするためのfactoryコンストラクタを宣言する
  factory ConnectionStatus() {
    return _instance;
  }

  //プライベートコンストラクタ
  ConnectionStatus._internal() {
    //ネットワークの疎通状況
    interNetConnected = true;
  }

}

// インスタンスへの参照を取得
final connectionStatus = ConnectionStatus();

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
  connectionStatus.interNetConnected = await checkConnectivity();
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
