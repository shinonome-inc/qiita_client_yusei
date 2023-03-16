import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/tag_detail_list_page.dart';
import 'package:provider/provider.dart';
import '../components/no_internet_widget.dart';
import '../main.dart';
import '../util/connection_status.dart';
import '../view_model/tag_view_model.dart';

class TagPage extends StatefulWidget {
  const TagPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  final TagViewModel tagViewModel = TagViewModel();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ConnectionStatus.checkConnectivity().then((isConnected) async {
        if (isConnected) {
          await tagViewModel.fetchTags();
        } else {
          setState(() {
            connectionStatus.interNetConnected = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height / 2.5;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 768) {
      // タブレット以上の場合は3列
      crossAxisCount = 3;
    }
    return Scaffold(
      appBar: connectionStatus.interNetConnected
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              shadowColor: Colors.white.withOpacity(0.3),
            ),
      body: ChangeNotifierProvider(
        create: (_) => tagViewModel,
        child: Consumer<TagViewModel>(
          builder: (context, model, child) {
            if (model.isLoading && model.tags.isEmpty) {
              //初期表示のインディケーター
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 22,
                  color: Color(0xFF6A717D),
                ),
              );
            } else if (!connectionStatus.interNetConnected &&
                model.tags.isEmpty) {
              return NoInternetWidget(
                onPressed: () async {
                  // ネットワーク接続状態を確認する
                  bool isConnected = await ConnectionStatus.checkConnectivity();
                  if (isConnected) {
                    setState(() {
                      connectionStatus.interNetConnected = true;
                    });
                    model.fetchTags();
                  } else {
                    // ネットワークに接続されていない場合はエラーメッセージを表示する
                    setState(() {
                      connectionStatus.interNetConnected = false;
                    });
                  }
                },
              );
            } else {
              return Stack(
                children: [
                  Visibility(
                    visible: model.tags.isNotEmpty,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!model.isLastPage &&
                            !model.isLoading &&
                            scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent + 10) {
                          model.fetchTags();
                        }

                        if (Theme.of(context).platform ==
                            TargetPlatform.android) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            model.fetchTags();
                          }
                        }
                        return false;
                      },
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                          //   child: Visibility(
                          //     visible: model.isLoading,
                          //     child: const Center(
                          //       child: CupertinoActivityIndicator(
                          //         radius: 18,
                          //         color: Color(0xFF6A717D),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: model.tags.isNotEmpty
                                  ? model.tags.length +
                                      (model.isLastPage ? 0 : 1)
                                  : 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == model.tags.length) {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 2, 0, 0, 0),
                                    child: SizedBox(
                                      width:MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: CupertinoActivityIndicator(
                                          radius: 18,
                                          color: Color(0xFF6A717D),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: itemWidth,
                                    height: itemHeight,
                                    child: TagCard(tag: model.tags[index]),
                                  );
                                }
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                                crossAxisCount: crossAxisCount,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //追加ローディング中は表示しない
                  Visibility(
                    visible: model.isLoading && model.tags.isEmpty,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        radius: 22,
                        color: Color(0xFF6A717D),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class TagCard extends StatelessWidget {
  final Tag tag;

  const TagCard({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TagDetailListPage(tag: tag),
            ),
          );
        },
        child: Consumer<TagViewModel>(
          builder: (context, model, child) {
            if (model.isLoading && model.tags.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (model.tags.isNotEmpty && model.tags.last == tag) {
              if (model.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (!model.isLastPage) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  tag.iconUrl,
                  width: 38,
                  height: 38,
                ),
                const SizedBox(height: 8),
                Text(
                  tag.name,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans JP',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    letterSpacing: 0.25,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '記事件数：${tag.itemsCount}',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans JP',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 12 / 12,
                    letterSpacing: 0,
                    color: Color(0xFF828282),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'フォロワー数：${tag.followersCount}',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans JP',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 12 / 12,
                    letterSpacing: 0,
                    color: Color(0xFF828282),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
