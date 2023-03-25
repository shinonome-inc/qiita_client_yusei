import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/tag.dart';

class QiitaApiService {
  // Qiita APIのエンドポイントURL
  String apiUrl = 'https://qiita.com/api/v2/items';

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
    required String pageName,
  }) async {
    if (!isLastPage) {
      if (pageName == "tag_detail_list") {
        apiUrl = "https://qiita.com/api/v2/tags/$searchKeyword/items";
      }

      String url = '$apiUrl?page=$currentPage&per_page=$perPage';

      // 検索キーワードがある場合、URLに追加する
      if (searchKeyword.isNotEmpty && pageName != "tag_detail_list") {
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
          print(url);

          // レスポンスをパースし、記事のリストを作成する
          final List<dynamic> newItems = json.decode(response.body);
          // print(newItems);
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

  Future<List<Tag>> fetchTagList(int currentPage, int perPage) async {
    // QiitaのAPIからタグ一覧を取得

    final response = await http.get(
      Uri.parse(
          'https://qiita.com/api/v2/tags?page=$currentPage&per_page=$perPage&sort=count'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('https://qiita.com/api/v2/tags?page=$currentPage&per_page=$perPage&sort=count');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) {
        return [];
      }
      final tags = data.map<Tag>((tagData) {
        final iconUrl = tagData['icon_url'];
        return Tag(
          name: tagData['id'] ?? '',
          iconUrl: iconUrl ?? 'https://via.placeholder.com/150?text=No+Image',
          followersCount: tagData['followers_count'] ?? 0,
          itemsCount: tagData['items_count'] ?? 0,
        );
      }).toList();
      return tags;
    } else {
      throw Exception('Failed to load tags');
    }
  }
}
