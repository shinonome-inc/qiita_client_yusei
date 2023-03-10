import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/qiita_api_service.dart';
import '../components/web_view_screen.dart';
import '../main.dart';
import 'package:flutter_app/components/no_internet_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key,}) : super(key: key);


  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  // 検索キーワード
  String searchKeyword = '';

  // ページネーションに利用する変数
  int currentPage = 1;
  int perPage = 20;
  bool isLoading = false;
  bool isLastPage = false;
  List<dynamic> itemsList = [];
  bool _firstLoading = true;

  final QiitaApiService _qiitaApiService = QiitaApiService();

  // ページを開いた時に一度だけQiitaの記事を取得する
  @override
  void initState() {
    super.initState();

    // fetchQiitaItems();
    Future.delayed(Duration.zero, () {
      checkConnectivity().then((isConnected) {
        if (isConnected) {
          pullQiitaItems();
        } else {
          setState(() {
            interNetConnected = false;
          });
        }
      });
      _firstLoading = false;
    });
  }
// qiita_api_service.dartのfetchQiitaItemsを呼び出し、記事を取得する
  Future<void> pullQiitaItems() async {
    if (!isLastPage) {
      setState(() {
        isLoading = true;
      });

      List<dynamic> newItems = await _qiitaApiService.fetchQiitaItems(
        currentPage: currentPage,
        perPage: perPage,
        searchKeyword: searchKeyword,
        isLastPage: isLastPage,
      );

      setState(() {
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
      });
    }
    _firstLoading = false;
  }


  // ListViewに表示する記事のWidgetを作成する
  Widget _buildListItem(
    BuildContext context,
    int index,
  ) {
    final item = itemsList[index];
    final user = item['user'];
    final formattedDate =
        DateFormat('yyyy/MM/dd').format(DateTime.parse(item['created_at']));
    final likeCount = item['likes_count'];

    return RefreshIndicator(
      onRefresh: () async {
        // スワイプ時に更新したい処理を書く
        await pullQiitaItems();
      },
      child: Column(
        children: [
          ListTile(
            leading: CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.person),
              imageUrl: user['profile_image_url'],
              width: 38,
              height: 38,
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
              child: Text(
                item['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.25,
                    color: Color(0xFF333333)),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 8),
              child: Text(
                '@${user['id']} 投稿日: $formattedDate いいね数: $likeCount',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 2.0,
                    color: Color(0xFF828282)),
              ),
            ),
            onTap: () async {
              await showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 11),
                        alignment: Alignment.bottomCenter,
                        height: 59,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(249, 249, 249, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Article',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontFamily: 'Pacifico', fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: WebViewPage(
                          urlString: item['url'],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(
            color: Color(0xFFB2B2B2),
            thickness: 0.5,
            height: 0,
            indent: 80,
          ),
        ],
      ),
    );
  }

  final _clearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double aspectRatio = size.aspectRatio;
    //アスペクト比でWidgetの幅と高さを補正

    if (aspectRatio >= 0.56 && aspectRatio < 0.65) {
      // 多くのスマホ（iPhone 5 ~ iPhone 8 Plus, iPhoneSE類）
    } else if (aspectRatio >= 0.65) {
      // 古い世代、タブレット（iPhone ~ iPhone 4s）
    } else {
      // 新世代 （iPhone X以降（iPhoneSEは除く））
    }
    return Scaffold(
      appBar: !interNetConnected
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              shadowColor: Colors.white.withOpacity(0.3),
              title: SizedBox(
                height: 36,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: const Color(0xFF74C13A)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      color: const Color(0xFF3C3C43).withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      height: 1,
                      letterSpacing: -0.41,
                    ),
                    controller: _clearController,
                    onChanged: (value) {
                      setState(() {
                        searchKeyword = value;
                      });
                    },

                    // 検索キーワードを更新すると同時に、記事を更新する
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(30, 7, 0, 7),
                      hintText: 'Search',
                      prefixIcon: const Icon(
                        Icons.search,
                        // color: Color(0xFF74C13A)
                      ),
                      suffixIcon: searchKeyword.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  searchKeyword = '';
                                });
                                _clearController.clear();
                              },
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.clear),
                              color: Colors.grey,
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFF767680).withOpacity(0.12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      body: Stack(
        children: [
          Visibility(
            visible: itemsList.isNotEmpty,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // リストの末尾にスクロールした場合、続きのページを読み込む
                if (!isLastPage &&
                    !isLoading &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent + 10) {
                  pullQiitaItems();
                }

                if (Theme.of(context).platform == TargetPlatform.android) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    pullQiitaItems();
                  }
                }

                return false;
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      //Listの最新記事取得スクロールの方向が変わる
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: itemsList.isNotEmpty
                          ? itemsList.length + (isLastPage ? 0 : 1)
                          : 1,
                      itemBuilder: (BuildContext context, int index) {
                        final padding =
                            Theme.of(context).platform == TargetPlatform.android
                                ? const EdgeInsets.fromLTRB(0, 40, 0, 30)
                                : const EdgeInsets.fromLTRB(0, 10, 0, 20);
                        if (index == itemsList.length) {
                          return Center(
                            child: Padding(
                              padding: padding,
                              child: isLoading
                                  ? const CupertinoActivityIndicator(
                                      radius: 18,
                                      color: Color(0xFF6A717D),
                                    )
                                  : Container(),
                            ),
                          );
                        } else {
                          return _buildListItem(context, index);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          //追加ローディング中は表示しない
          Visibility(
              visible: isLoading && itemsList.isEmpty,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 22,
                  color: Color(0xFF6A717D),
                ),
              )),

          NoInternetWidget(
            interNetConnected: interNetConnected,
            onPressed: () async {
              // ネットワーク接続状態を確認する
              bool isConnected = await checkConnectivity();
              if (isConnected) {
                setState(() {
                  interNetConnected = true;
                });
                pullQiitaItems();
              } else {
                // ネットワークに接続されていない場合はエラーメッセージを表示する
                setState(() {
                  interNetConnected = false;
                });
              }
            },
          ),

          Visibility(
            visible: !(itemsList.isNotEmpty) &&
                !isLoading &&
                !_firstLoading &&
                interNetConnected,
            child: _buildNoResultWidget(),
          ),
        ],
      ),
    );
  }

// TextFieldでEnterを押した時に呼ばれる

  Future<void> _handleSubmitted(String value) async {
    setState(() {
      searchKeyword = value;
      _firstLoading = true;
      currentPage = 1;
      isLastPage = false;
    });
    itemsList.clear();
    await pullQiitaItems();
  }

  // ListViewに表示する記事がない場合に表示するWidget
// ListViewに表示する記事がない場合に表示するWidget
  Widget _buildNoResultWidget() {
    if (!interNetConnected && itemsList.isEmpty) {
      return Container();
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 227),
            child: Column(
              children: const [
                Icon(Icons.search_off, size: 48),
                Text(
                  '検索にマッチする記事はありませんでした',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                    letterSpacing: -0.24,
                  ),
                ),
                SizedBox(height: 17),
                Text(
                  '検索条件を変えるなどして、再度検索してください。',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF828282),
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}