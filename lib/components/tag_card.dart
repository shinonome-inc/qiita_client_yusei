// import 'package:flutter/material.dart';
// import 'package:flutter_app/screens/tag_detail_list_page.dart';
// import 'package:provider/provider.dart';
// import '../model/tag.dart';
// import '../view_model/tag_view_model.dart';
// import 'loading_widget.dart';

//
// class TagCard extends StatelessWidget {
//   final Tag tag;
//
//   const TagCard({Key? key, required this.tag}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(
//           color: Color(0xFFE0E0E0),
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TagDetailListPage(tag: tag),
//             ),
//           );
//         },
//         child: Consumer<TagViewModel>(
//           builder: (context, model, child) {
//             if (model.isLoading && model.tags.isEmpty) {
//               return const LoadingWidget(isCircle: true);
//             } else if (model.tags.isNotEmpty && model.tags.last == tag) {
//               if (model.isLoading) {
//                 return const LoadingWidget(isCircle: true);
//               } else if (!model.isLastPage) {
//                 return const LoadingWidget(isCircle: true);
//               }
//             }
//             return SizedBox(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.network(
//                     tag.iconUrl,
//                     width: 38,
//                     height: 38,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     tag.name,
//                     style: const TextStyle(
//                       fontFamily: 'Noto Sans JP',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       height: 20 / 14,
//                       letterSpacing: 0.25,
//                       color: Color(0xFF333333),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '記事件数：${tag.itemsCount}',
//                     style: const TextStyle(
//                       fontFamily: 'Noto Sans JP',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       height: 1,
//                       letterSpacing: 0,
//                       color: Color(0xFF828282),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     'フォロワー数：${tag.followersCount}',
//                     style: const TextStyle(
//                       fontFamily: 'Noto Sans JP',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       height: 1,
//                       letterSpacing: 0,
//                       color: Color(0xFF828282),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/tag_detail_list_page.dart';
import 'package:provider/provider.dart';
import '../model/tag.dart';
import '../view_model/tag_view_model.dart';
import 'loading_widget.dart';
import 'tag_card_text.dart';

class TagCard extends StatelessWidget {
  final Tag tag;

  const TagCard({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFFE0E0E0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
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
            if (model.isLoading && model.tags.isEmpty ||
                model.tags.isNotEmpty &&
                    model.tags.last == tag &&
                    model.isLoading ||
                model.tags.isNotEmpty &&
                    !model.isLastPage &&
                    model.tags.last == tag) {
              return const LoadingWidget(isCircle: true);
            }

            return SizedBox(
              child: Column(
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
                  Column(
                    children: [
                      TagCardText(label: '記事件数：', tag: tag),
                      TagCardText(label: 'フォロワー数：', tag: tag),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
