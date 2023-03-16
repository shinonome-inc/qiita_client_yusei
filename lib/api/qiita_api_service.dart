import 'dart:convert';

import 'package:http/http.dart' as http;

class QiitaApiService {
  // Qiita APIのエンドポイントURL
  final String apiUrl = 'https://qiita.com/api/v2/items';

  // Qiita APIのアクセストークン
  // TODO 認証系実装時に削除する
  final String accessToken = 'b1150483b71f6070cb3f9388cb03993bc510987d';

  // キャッシュのための変数
  final Map<String, dynamic> cache = {};

  Future<List<dynamic>> fetchQiitaItems({
    required int currentPage,
    required int perPage,
    required String searchKeyword,
    required bool isLastPage,
  }) async {
    if (!isLastPage) {
      String url = '$apiUrl?per_page=$perPage&page=$currentPage';

      // 検索キーワードがある場合、URLに追加する
      if (searchKeyword.isNotEmpty) {
        url += '&query=$searchKeyword';
      }

      // キャッシュがある場合、キャッシュを使用する
      if (cache.containsKey(url)) {
        final List<dynamic> itemsList = cache[url];
        if (itemsList.length < perPage) {
          isLastPage = true;
        }
        return itemsList;
      } else {
        try {
          // Qiita APIにリクエストを送信する
          final response = await http.get(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          );

          // レスポンスをパースし、記事のリストを作成する
          final List<dynamic> newItems = json.decode(response.body);

          // キャッシュに記事を追加する
          cache[url] = newItems;

          // キャッシュのクリア
          if (cache.length > 10) {
            cache.remove(cache.keys.first);
          }

          if (newItems.isEmpty) {
            // 検索結果が見つからなかった場合は、現在の記事リストをクリアして、最初のページから再度取得する
            isLastPage = true;
            return [];
          } else {
            if (newItems.length < perPage) {
              isLastPage = true;
            }
            return newItems;
          }
        } catch (e) {
            print('fetchQiitaItems error: $e');
          return [];
        }
      }
    }
    return [];
  }
}