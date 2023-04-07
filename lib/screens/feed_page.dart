import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/article_list_body.dart';
import '../components/custom_appbar.dart';
import '../components/no_internet_widget.dart';
import '../main.dart';
import '../util/connection_status.dart';
import '../view_model/feed_view_model.dart';
import '../model/page_name.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedPage> createState() =>
      FeedPageState(); // _FeedPageViewState を使用するように変更
}

class FeedPageState extends State<FeedPage> {
  FeedViewModel feedViewModel = FeedViewModel();
  TextEditingController clearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (connectionStatus.interNetConnected) {
      // ネットワーク接続ありの場合のウィジェット
      return Scaffold(body: _buildLists());
    } else {
      // ネットワーク接続なしの場合のウィジェット
      return _buildNoInternetWidget();
    }
  }

  Widget _buildNoInternetWidget() {
    // ネットワークに接続されていない時はNoInterNetWidgetを表示する
    return NoInternetWidget(
      onPressed: () async {
        if (await ConnectionStatus.checkConnectivity()) {
          connectionStatus.interNetConnected = true;
          setState(() {});
        } else {
          connectionStatus.interNetConnected = false;
        }
      },
    );
  }

  Widget _buildLists() {
    return Scaffold(
      // ネットワーク接続がある時のみ専用のAppBarを表示
      appBar: !connectionStatus.interNetConnected
          ? null
          : CustomAppBar(
        title: 'Feed',
        titleWidget: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 27, bottom: 19),
              child: Text(
                'Feed',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 36,
              width: MediaQuery.of(context).size.width,
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
                  controller: clearController,
                  onChanged: (value) {
                    setState(() {
                      feedViewModel.searchKeyword = value;
                    });
                  },

                  // 検索キーワードを更新すると同時に、記事を更新する
                  onSubmitted: (String value) async {
                    await feedViewModel.handleSubmitted(value);
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.fromLTRB(30, 7, 0, 7),
                    hintText: 'Search',
                    prefixIcon: const Icon(
                      Icons.search,
                      // color: Color(0xFF74C13A)
                    ),
                    suffixIcon: feedViewModel.searchKeyword.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        setState(() {
                          feedViewModel.searchKeyword = '';
                        });
                        clearController.clear();
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
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      body: ChangeNotifierProvider(
          create: (_) => feedViewModel,
          child: const ArticleDetailListBodyContent(
            tag: null,
            pageName: PageName.feed,
          )),
    );
  }
}
