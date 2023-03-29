import 'package:flutter/material.dart';
import '../components/article_list_body.dart';
import '../main.dart';
import '../model/tag.dart';
import '../view_model/feed_view_model.dart';
import '../model/page_name.dart';

class TagDetailListPage extends StatefulWidget {
  final Tag tag;

  const TagDetailListPage({Key? key, required this.tag}) : super(key: key);

  @override
  State<TagDetailListPage> createState() => _TagDetailListPageState();
}

class _TagDetailListPageState extends State<TagDetailListPage> {
  final FeedViewModel feedViewModel = FeedViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !connectionStatus.interNetConnected
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  iconSize: 28,
                  color: const Color(0xFF468300),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                shadowColor: Colors.white.withOpacity(0.3),
                title: Text(
                  widget.tag.name,
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
        body: ArticleDetailListBody(
          tag: widget.tag,
          pageName: PageName.tagDetailList,
        ));
  }
}
