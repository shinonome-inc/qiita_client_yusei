import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.titleWidget, //Feedページ限定
  }) : super(key: key);
  final String title;
  final Widget? titleWidget;

  @override
  Size get preferredSize => title == 'Feed'
      ? const Size.fromHeight(114.0)
      : const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    if (title == 'Feed') {}
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.white.withOpacity(0.3),
      automaticallyImplyLeading: false,
      title: title.isNotEmpty ? _buildTitle() : null,
      centerTitle: true,
      toolbarHeight: preferredSize.height,
    );
  }

  Widget _buildTitle() {
    if (title == 'Feed') {
      return titleWidget ?? const SizedBox.shrink();
    } else {
      return Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 17.0,
          color: Colors.black,
        ),
      );
    }
  }
}