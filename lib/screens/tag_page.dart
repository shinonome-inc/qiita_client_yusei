import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/loading_widget.dart';
import '../components/no_internet_widget.dart';
import '../components/tag_card.dart';
import '../main.dart';
import '../util/connection_status.dart';
import '../view_model/tag_view_model.dart';

class TagPage extends StatefulWidget {
  const TagPage({Key? key}) : super(key: key);

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  final TagViewModel tagViewModel = TagViewModel();

  @override
  void initState() {
    super.initState();
    Future(() async {
      await ConnectionStatus.checkConnectivity().then((isConnected) {
        if (isConnected) {
          tagViewModel.firstLoading = true;
          tagViewModel.fetchTags();
        } else {
          connectionStatus.interNetConnected = false;
        }
      });
    });
  }

  Widget _buildInitialLoadingWidget() {
    return const LoadingWidget(radius: 22.0, color: Color(0xFF6A717D));
  }

  Widget _buildNoInternetWidget() {
    return NoInternetWidget(
      onPressed: () async {
        if (await ConnectionStatus.checkConnectivity()) {
          connectionStatus.interNetConnected = true;
          tagViewModel.firstLoading = true;
          tagViewModel.fetchTags();
        } else {
          connectionStatus.interNetConnected = false;
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const LoadingWidget(radius: 18.0, color: Color(0xFF6A717D));
  }

  Widget _buildTagsGridView(TagViewModel model) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 768 ? 3 : 2;
    final paddingLeft = screenWidth > 768
        ? MediaQuery.of(context).size.width / 2.1
        : screenWidth / 2.38;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!model.isLastPage && !model.isLoading &&
            ((Theme.of(context).platform == TargetPlatform.android &&
                scrollInfo.metrics.atEdge &&
                scrollInfo.metrics.pixels > 0) ||
                (Theme.of(context).platform == TargetPlatform.iOS &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent + 5))) {
          model.fetchTags();
          print("${Theme.of(context).platform} scroll");
        }

        return false;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: model.tags.isNotEmpty
              ? model.tags.length + (model.isLastPage ? 0 : 1)
              : 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == model.tags.length) {
              return Padding(
                padding: EdgeInsets.fromLTRB(paddingLeft, 0, 0, 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: _buildLoadingWidget(),
                ),
              );
            } else {
              return TagCard(tag: model.tags[index]);
            }
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: crossAxisCount,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: tagViewModel,
        child: Consumer<TagViewModel>(
          builder: (context, model, child) {
            if (model.firstLoading &&
                model.tags.isEmpty &&
                connectionStatus.interNetConnected) {
              return _buildInitialLoadingWidget();
            } else if (!connectionStatus.interNetConnected &&
                model.tags.isEmpty) {
              return _buildNoInternetWidget();
            } else {
              return Stack(
                children: [
                  Visibility(
                    visible: model.tags.isNotEmpty,
                    child: _buildTagsGridView(model),
                  ),
                  // Visibility(
                  //   visible: model.isLoading && model.tags.isEmpty,
                  //   child: _buildInitialLoadingWidget(),
                  // ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
