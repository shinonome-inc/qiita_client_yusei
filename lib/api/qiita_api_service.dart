import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../model/user.dart';
import '../model/tag.dart';
import '../model/page_name.dart';
import 'package:flutter_app/config/keys.dart';

class QiitaApiService {
  static const clientId = Keys.clientId;
  static const clientSecret = Keys.clientSecret;

  static String displayAllowPage(String state) {
    const scope = "read_qiita";
    return "https://qiita.com/api/v2/oauth/authorize?client_id=$clientId&scope=$scope&state=$state";
  }

  static Future<String> issueAccessToken(Uri uri, String expectedState) async {
    final String? code = uri.queryParameters["code"];
    final String? state = uri.queryParameters["state"];
    if (state != expectedState) {
      throw Exception("state is different from expectedState");
    }

    final response = await http.post(
      Uri.parse("https://qiita.com/api/v2/access_tokens"),
      headers: {
        "content-type": "application/json",
      },
      body: jsonEncode(
        {
          "client_id": clientId,
          "client_secret": clientSecret,
          "code": code,
        },
      ),
    );

    if (response.statusCode == 201) {
      final body = json.decode(response.body);
      final accessToken = body["token"];
      print("accessTocken: $accessToken");
      return accessToken;
    } else {
      throw Exception("accessToken couldn't issue");
    }
  }

  // キャッシュのための変数
  final Map<String, dynamic> cache = {};

  Future<List<dynamic>> fetchQiitaItems({
    required int currentPage,
    required int perPage,
    required String searchKeyword,
    required bool isLastPage,
    required PageName pageName,
  }) async {
    if (!isLastPage) {
      // Qiita APIのエンドポイントURL
      String apiUrl = '';
      switch (pageName) {
        case PageName.feed:
          apiUrl = 'https://qiita.com/api/v2/items';
          break;
        case PageName.tagDetailList:
          apiUrl = 'https://qiita.com/api/v2/tags/$searchKeyword/items';
          break;
        case PageName.myPage:
          apiUrl = 'https://qiita.com/api/v2/authenticated_user/items';
          break;
      }
      String url = '$apiUrl?page=$currentPage&per_page=$perPage';

      // 検索キーワードがある場合、URLに追加する
      if (searchKeyword.isNotEmpty && pageName == PageName.feed) {
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
          late http.Response response;
          print(accessToken);
          // Qiita APIにリクエストを送信する
          response = await http.get(
            Uri.parse(url),
            headers: (accessToken != '')
                ? {
                    'Authorization': 'Bearer $accessToken',
                  }
                : null,
          );

          // レスポンスをパースし、記事のリストを作成する
          final List<dynamic> newItems = json.decode(response.body);
          print(url);

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

    late http.Response response;

    response = await http.get(
      Uri.parse(
          'https://qiita.com/api/v2/tags?page=$currentPage&per_page=$perPage&sort=count'),
      headers: (accessToken != '')
          ? {
              'Authorization': 'Bearer $accessToken',
            }
          : null,
    );
    print(
        'https://qiita.com/api/v2/tags?page=$currentPage&per_page=$perPage&sort=count');
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

  Future<User> fetchUserData() async {
    //QiitaのAPIから、マイページの認証済みユーザーの情報を取得する

    late Response response;
    final dio = Dio();

    response = await dio.get(
      'https://qiita.com/api/v2/authenticated_user',
      options: Options(
        headers: (accessToken != '')
            ? {
                'Authorization': 'Bearer $accessToken',
              }
            : null,
      ),
    );

    print("##### Current User Data #####");
    print("");
    print(response.data);
    print("");
    print("############################# ");

    final userData = User(
      iconUrl: response.data['profile_image_url'] ??
          'https://via.placeholder.com/150?text=No+Image',

      //Googleアカウントなどでログインしている場合は名前がない（空文字で返ってくる）
      name: response.data['name'] != null && response.data['name'] != ""
          ? response.data['name']
          : 'ユーザー名が未登録です',
      id: response.data['id'] ?? 'ユーザーIDが指定されていません',
      description: response.data['description'] ?? '詳細がありません',
      followeesCount: response.data['followees_count'] ?? 0,
      followersCount: response.data['followers_count'] ?? 0,
    );
    return userData;
  }
}
