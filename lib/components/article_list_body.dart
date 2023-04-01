import 'package:flutter/material.dart';
import 'package:flutter_app/components/article_list.dart';
import 'package:flutter_app/components/no_internet_widget.dart';
import 'package:flutter_app/model/tag.dart';
import 'package:flutter_app/util/connection_status.dart';
import 'package:flutter_app/view_model/feed_view_model.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../view_model/my_page_view_model.dart';
import 'loading_widget.dart';
import 'my_page_profile.dart';
import '../model/page_name.dart';

class ArticleDetailListBody extends StatelessWidget {
  final Tag? tag;
  final PageName pageName;

  const ArticleDetailListBody({Key? key, this.tag, required this.pageName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedViewModel(),
      child: ArticleDetailListBodyContent(tag: tag, pageName: pageName),
    );
  }
}

class ArticleDetailListBodyContent extends StatefulWidget {
  final Tag? tag;
  final PageName pageName;

  const ArticleDetailListBodyContent(
      {Key? key, this.tag, required this.pageName})
      : super(key: key);

  @override
  State<ArticleDetailListBodyContent> createState() =>
      ArticleDetailListBodyContentState();
}

class ArticleDetailListBodyContentState
    extends State<ArticleDetailListBodyContent> {
  late final FeedViewModel _feedViewModel;
  late final MyPageViewModel _myPageViewModel;

  @override
  void initState() {
    super.initState();
    _feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    _myPageViewModel = MyPageViewModel();
    Future(() async {
      await fetchItems(_feedViewModel, widget.pageName, widget.tag);
    });
  }

  Future<void> fetchItems(
      FeedViewModel model, PageName pageName, Tag? tag) async {
    if (await ConnectionStatus.checkConnectivity()) {
      connectionStatus.interNetConnected = true;
      if (pageName == PageName.tagDetailList) {
        await model.searchQiitaItems(tag!.name, PageName.tagDetailList);
      } else {
        if (pageName == PageName.myPage) {
          await _myPageViewModel.fetchUser();
        }
        await model.pullQiitaItems(pageName);
      }
    } else {
      connectionStatus.interNetConnected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(
      builder: (context, model, child) {
        Widget content;
        content = _buildContent(model);
        return content;
      },
    );
  }

  Widget _buildContent(FeedViewModel model) {
    if (model.isLoading &&
        model.itemsList.isEmpty &&
        widget.pageName != PageName.myPage) {
      return const LoadingWidget(radius: 22.0, color: Color(0xFF6A717D));
    }

    if (!connectionStatus.interNetConnected && model.itemsList.isEmpty) {
      return NoInternetWidget(
        onPressed: () async {
          await fetchItems(
              context.read<FeedViewModel>(), widget.pageName, widget.tag);
        },
      );
    }

    final deviceHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // if (model.itemsList.isNotEmpty)
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!model.isLastPage &&
                !model.isLoading &&
                ((Theme.of(context).platform == TargetPlatform.android &&
                        scrollInfo.metrics.atEdge &&
                        scrollInfo.metrics.pixels > 0) ||
                    (Theme.of(context).platform == TargetPlatform.iOS &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent + 5))) {
              model.pullQiitaItems(widget.pageName);
              print("${Theme.of(context).platform} scroll");
            }
            return false;
          },
          child: Column(
            children: [
              Visibility(
                //マイページでのみ表示
                visible: widget.pageName == PageName.myPage,
                child: Column(
                  children: [
                    SizedBox(
                        height: deviceHeight * 0.313,
                        child: MyPageProfile(model: _myPageViewModel)),
                    const SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
              Visibility(
                //タグ詳細ページと、マイページでのみ表示
                visible: widget.pageName == PageName.tagDetailList ||
                    widget.pageName == PageName.myPage,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    color: const Color(0xFFf2f2f2),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 12.0, top: 8.0, bottom: 8.0),
                      child: const Text(
                        '投稿記事',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF828282),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.itemsList.isNotEmpty
                      ? model.itemsList.length + (model.isLastPage ? 0 : 1)
                      : 1,
                  itemBuilder: (BuildContext context, int index) {
                    final padding =
                        Theme.of(context).platform == TargetPlatform.android
                            ? const EdgeInsets.fromLTRB(0, 40, 0, 30)
                            : const EdgeInsets.fromLTRB(0, 10, 0, 20);
                    if (index == model.itemsList.length) {
                      return Stack(children: [
                        Center(
                          child: Padding(
                            padding: padding,
                            child: model.isLoading && widget.pageName != PageName.myPage
                                ? const LoadingWidget(
                                    radius: 18.0, color: Color(0xFF6A717D))
                                : Container(),
                          ),
                        ),
                      ]);
                    } else {
                      return ArticleList(
                        feedViewModel: _feedViewModel,
                        index: index,
                        tag: widget.tag,
                        itemsList: model.itemsList,
                        pageName: widget.pageName,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        if (widget.pageName == PageName.feed &&
            !(model.itemsList.isNotEmpty) &&
            !model.isLoading &&
            !model.firstLoading &&
            connectionStatus.interNetConnected)
          _buildNoResultWidget(),
        // if (model.isLoading && model.itemsList.isEmpty)
        //   const LoadingWidget(radius: 22.0, color: Color(0xFF6A717D)),
        if (!connectionStatus.interNetConnected && model.itemsList.isEmpty)
          Container(),
      ],
    );
  }

  Widget _buildNoResultWidget() {
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
