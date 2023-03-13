import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.colors,
    required this.btnLoading,
    this.loadingSeconds = 3,
  }) : super(key: key);
  final int colors;
  final String text;
  final VoidCallback onPressed;
  final int loadingSeconds;
  final bool btnLoading;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isLoading = false;

  void _loadingToFeed() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: widget.loadingSeconds));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double deviceWidth;
    double deviceHeight = size.height - AppBar().preferredSize.height;
    double aspectRatio = size.aspectRatio;
    //アスペクト比でWidgetの幅と高さを補正

    if (aspectRatio >= 0.56 && aspectRatio < 0.65) {
      // 多くのスマホ（iPhone 5 ~ iPhone 8 Plus, iPhoneSE類）
      deviceWidth = size.width * 0.9;
      deviceHeight = size.height * 0.9;
    } else if (aspectRatio >= 0.65) {
      // 古い世代、タブレット（iPhone ~ iPhone 4s）
      deviceWidth = size.width * 0.65;
      deviceHeight = size.height * 0.8;
    } else {
      // 新世代 （iPhone X以降（iPhoneSEは除く））
      deviceWidth = size.width;
      deviceHeight = size.height;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(widget.colors),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        minimumSize: Size(deviceWidth, deviceHeight),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: Visibility(
                visible: widget.btnLoading,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            )
          : Text(
              widget.text,
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFFF9FCFF),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.75,
                height: 1.14,
              ),
            ),
      onPressed: () {
        _loadingToFeed();
        widget.onPressed.call();
      },
    );
  }
}
