import '../api/qiita_api_service.dart';
import 'package:flutter/material.dart';
import '../model/tag.dart';

class TagViewModel extends ChangeNotifier {
  final List<Tag> _tags = [];
  bool _isLoading = true;
  int _columnCount = 2;
  final QiitaApiService _qiitaApiService = QiitaApiService();
  bool _isLastPage = false;
  bool _firstLoading = false;
  final int _perPage = 20;

  List<Tag> get tags => _tags;

  bool get isLoading => _isLoading;

  bool get firstLoading => _firstLoading;

  int get columnCount => _columnCount;

  bool get isLastPage => _isLastPage;

  set firstLoading(bool value) {
    _firstLoading = value;
    notifyListeners();
  }

  Future<void> fetchTags() async {
    if (_isLastPage) {
      return;
    }

    if (!isLastPage) {
      _isLoading = true;
      notifyListeners();
    }

    // タグ一覧を取得
    List<Tag> newTags = await _qiitaApiService.fetchTagList(
        _tags.length ~/ _perPage + 1, _perPage);

    if (newTags.isEmpty) {
      _isLastPage = true;
    }

    // 取得したタグを既存のタグリストに追加
    _tags.addAll(newTags);
    _isLoading = false;
    _firstLoading = false;
    notifyListeners();
  }

  void updateColumnCount(double width) {
    if (width < 600) {
      _columnCount = 2;
    } else if (width < 900) {
      _columnCount = 3;
    } else {
      _columnCount = 4;
    }
    notifyListeners();
  }
}
