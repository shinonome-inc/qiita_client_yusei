import 'package:flutter/material.dart';
import '../api/qiita_api_service.dart';

class MyPageViewModel extends ChangeNotifier {
  final QiitaApiService _qiitaApiService = QiitaApiService();
  bool isLoading = false;
  String errorMessage = '';
  String iconUrl = '';
  String name = '';
  String id = '';
  String description = '';
  int followeesCount = 0;
  int followersCount = 0;

  Future<void> fetchUser() async {
    print("fetch!!");
    isLoading = true;
    notifyListeners();

    try {
      final currentUser = await _qiitaApiService.fetchUserData();
      // 取得したタグを既存のタグリストに追加
      iconUrl = currentUser.iconUrl;
      name = currentUser.name;
      id = currentUser.id;
      description = currentUser.description;
      followeesCount = currentUser.followeesCount;
      followersCount = currentUser.followersCount;
    } catch (e) {
      errorMessage = 'ユーザー情報の取得に失敗しました';
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }
}
