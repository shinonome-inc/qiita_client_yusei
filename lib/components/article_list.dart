import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/tag.dart';
import '../view_model/feed_view_model.dart';
import '../components/web_view_screen.dart';
import '../components/custom_modal.dart';

class ArticleList extends StatelessWidget {
  final FeedViewModel feedViewModel;
  final Tag? tag;
  final List<dynamic> itemsList;
  final int index;
  final String pageName;

  const ArticleList(
      {super.key,
      required this.feedViewModel,
      required this.tag,
      required this.itemsList,
      required this.index,
      required this.pageName});

  @override
  Widget build(BuildContext context) {
    final item = feedViewModel.itemsList[index];
    final user = item['user'];
    final formattedDate =
        DateFormat('yyyy/MM/dd').format(DateTime.parse(item['created_at']));
    final likeCount = item['likes_count'];

    return RefreshIndicator(
      onRefresh: () async {
        if (pageName == "feed") {
          feedViewModel.pullQiitaItems(pageName);
        } else {
          await feedViewModel.searchQiitaItems(tag!.name, "tag_detail_list");
        }
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
              await customModal(context, WebViewPage(urlString: item['url']));
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
}
