import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/article_list_body.dart';
import '../main.dart';
import '../view_model/feed_view_model.dart';
import '../model/page_name.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedPage> createState() =>
      _FeedPageState(); // _FeedPageViewState を使用するように変更
}

class _FeedPageState extends State<FeedPage> {
  final FeedViewModel feedViewModel = FeedViewModel();
  final _clearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !connectionStatus.interNetConnected
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
                        feedViewModel.searchKeyword = value;
                      });
                    },

                    // 検索キーワードを更新すると同時に、記事を更新する
                    onSubmitted: (String value) async {
                      await feedViewModel.handleSubmitted(value);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(30, 7, 0, 7),
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
      body: ChangeNotifierProvider(
          create: (_) => feedViewModel,
          child: const ArticleDetailListBodyContent(
              tag: null, pageName: PageName.feed)),
    );
  }
}
