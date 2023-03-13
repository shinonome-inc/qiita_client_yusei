import 'package:flutter/cupertino.dart';
import 'package:flutter_app/api/qiita_api_service.dart';

class FeedViewModel extends ChangeNotifier {
  final QiitaApiService _qiitaApiService = QiitaApiService();

  // 検索キーワード
  String searchKeyword = '';

  // ページネーションに利用する変数
  int currentPage = 1;
  int perPage = 20;
  bool isLoading = false;
  bool isLastPage = false;
  List<dynamic> itemsList = [];
  bool firstLoading = true;

  // Qiitaの記事を取得する
  Future<void> pullQiitaItems() async {
    if (!isLastPage) {
      isLoading = true;
      notifyListeners();

      List<dynamic> newItems = await _qiitaApiService.fetchQiitaItems(
        currentPage: currentPage,
        perPage: perPage,
        searchKeyword: searchKeyword,
        isLastPage: isLastPage,
      );

      if (newItems.isEmpty) {
        // 検索結果が見つからなかった場合は、現在の記事リストをクリアして、最初のページから再度取得する
        itemsList.clear();
        isLastPage = true;
      } else {
        itemsList.addAll(newItems);
        currentPage++;
        if (newItems.length < perPage) {
          isLastPage = true;
        }
      }

      isLoading = false;
      notifyListeners();
    }
    firstLoading = false;
  }

  // TextFieldでEnterを押した時に呼ばれる
  Future<void> searchQiitaItems(String value) async {
    searchKeyword = value;
    firstLoading = true;
    currentPage = 1;
    isLastPage = false;
    itemsList.clear();
    await pullQiitaItems();
  }

  // TextFieldでEnterを押した時に呼ばれる

  Future<void> handleSubmitted(String value) async {
    searchKeyword = value;
    firstLoading = true;
    currentPage = 1;
    isLastPage = false;
    itemsList.clear();
    await searchQiitaItems(value);
  }
}
