import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/view_model/my_page_view_model.dart';
import 'package:provider/provider.dart';

class MyPageProfile extends StatelessWidget {
  final MyPageViewModel model;

  const MyPageProfile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final deviceWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => model,
          child: Consumer<MyPageViewModel>(builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(
              child: CircularProgressIndicator(),
              );
            } else if (model.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  model.errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 0, 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                        imageUrl: model.iconUrl,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: deviceWidth,
                          child: Text(
                            model.name,
                            style: const TextStyle(
                                fontFamily: 'Noto Sans JP',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: 0.25,
                                color: Color(0xFF333333)
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: SizedBox(
                            width: deviceWidth,
                            child: Text('@${model.id}',
                                style: const TextStyle(
                                    fontFamily: 'Noto Sans JP',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.25,
                                    color: Color(0xFF828282))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 16, right: 24),
                          child: SizedBox(
                            width: deviceWidth,
                            child: Text(model.description ,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: 'Noto Sans JP',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.25,
                                    color: Color(0xFF828282))),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                  ),
                                ),
                                child: Text(
                                  '${model.followeesCount} フォロー中',
                                  style: const TextStyle(
                                    fontFamily: 'Noto Sans JP',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.25,
                                    color: Color(0xFF828282),
                                    height: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    padding:
                                    MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                    ),
                                  ),
                                  child: Text(
                                    '${model.followersCount} フォロワー',
                                    style: const TextStyle(
                                      fontFamily: 'Noto Sans JP',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      letterSpacing: 0.25,
                                      color: Color(0xFF828282),
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    }
}
