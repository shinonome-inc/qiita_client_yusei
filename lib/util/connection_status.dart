import 'package:connectivity/connectivity.dart';

class ConnectionStatus {
  late bool interNetConnected;
  static final ConnectionStatus _instance = ConnectionStatus._internal();

  // 唯一のインスタンスにアクセスするためのfactoryコンストラクタを宣言する
  factory ConnectionStatus() {
    return _instance;
  }

  //プライベートコンストラクタ（ネットワークの疎通状況を返す）
  ConnectionStatus._internal() : interNetConnected = true;

  // クラス内で唯一のインスタンスを保持するための静的変数を宣言する
  static Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}