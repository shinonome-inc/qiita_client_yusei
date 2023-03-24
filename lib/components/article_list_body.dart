import 'package:flutter/material.dart';
import 'package:flutter_app/components/article_list.dart';
import 'package:flutter_app/components/no_internet_widget.dart';
import 'package:flutter_app/model/tag.dart';
import 'package:flutter_app/util/connection_status.dart';
import 'package:flutter_app/view_model/feed_view_model.dart';
import 'package:provider/provider.dart';

// import '../api/qiita_api_service.dart';
import '../main.dart';
import 'loading_widget.dart';

class ArticleDetailListBody extends StatelessWidget {
  final Tag? tag;
  final String pageName;

  const ArticleDetailListBody({Key? key, this.tag, required this.pageName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedViewModel(),
      child: _ArticleDetailListBodyContent(tag: tag, pageName: pageName),
    );
  }
}

class _ArticleDetailListBodyContent extends StatefulWidget {
  final Tag? tag;
  final String pageName;

  const _ArticleDetailListBodyContent(
      {Key? key, this.tag, required this.pageName})
      : super(key: key);

  @override
  State<_ArticleDetailListBodyContent> createState() =>
      _ArticleDetailListBodyContentState();
}

class _ArticleDetailListBodyContentState
    extends State<_ArticleDetailListBodyContent> {
  late final FeedViewModel _feedViewModel;

  @override
  void initState() {
    super.initState();
    // QiitaApiService().isMyPage = false;
    _feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    Future(() async {
      await fetchItems(_feedViewModel, widget.pageName, widget.tag);
    });
  }

  Future<void> fetchItems(
      FeedViewModel model, String pageName, Tag? tag) async {
    if (await ConnectionStatus.checkConnectivity()) {
      connectionStatus.interNetConnected = true;
      if (pageName == "tag_detail_list") {
        await model.searchQiitaItems(tag!.name);
      } else {
        await model.pullQiitaItems();
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
        if (model.isLoading && model.itemsList.isEmpty) {
          content = const LoadingWidget(radius: 22.0, color: Color(0xFF6A717D));
        } else if (!connectionStatus.interNetConnected &&
            model.itemsList.isEmpty) {
          content = NoInternetWidget(
            onPressed: () async {
              await fetchItems(
                  context.read<FeedViewModel>(), widget.pageName, widget.tag);
            },
          );
        } else {
          content = _buildContent(model);
        }
        return content;
      },
    );
  }

  Widget _buildContent(FeedViewModel model) {
    if (model.isLoading && model.itemsList.isEmpty) {
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

    return Stack(
      children: [
        if (model.itemsList.isNotEmpty)
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!model.isLastPage &&
                  !model.isLoading &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent + 10) {
                model.pullQiitaItems();
              }

              if (Theme.of(context).platform == TargetPlatform.android) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  model.pullQiitaItems();
                }
              }
              return false;
            },
            child: Column(
              children: [
                Visibility(
                  //タグ詳細ページでのみ表示
                  visible: widget.pageName == "tag_detail_list",
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
                        return Center(
                          child: Padding(
                            padding: padding,
                            child: model.isLoading
                                ? const LoadingWidget(
                                    radius: 18.0, color: Color(0xFF6A717D))
                                : Container(),
                          ),
                        );
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
        if (widget.pageName == "feed" &&
            !(model.itemsList.isNotEmpty) &&
            !model.isLoading &&
            !model.firstLoading &&
            connectionStatus.interNetConnected)
          _buildNoResultWidget(),
        if (model.isLoading && model.itemsList.isEmpty)
          const LoadingWidget(radius: 22.0, color: Color(0xFF6A717D)),
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
