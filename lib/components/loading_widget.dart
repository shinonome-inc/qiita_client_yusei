import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.radius = 22.0,
    this.color = Colors.blue,
    this.isCircle = false,
  }) : super(key: key);

  final double radius;
  final Color color;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    Widget indicator;

    if (isCircle) {
      indicator = CircularProgressIndicator(
        strokeWidth: 2.0,
        color: color,
      );
    } else {
      indicator = CupertinoActivityIndicator(
        radius: radius,
        color: color,
        animating: true,
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: indicator,
      ),
    );
  }
}
