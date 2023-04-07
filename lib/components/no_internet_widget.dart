import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_appbar.dart';

import 'custom_btn.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const NoInternetWidget(
      {Key? key, required this.onPressed,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: deviceHeight * 0.2),
            SizedBox(
              height: 66.67,
              width: 66.67,
              child: Image.asset(
                'assets/images/no_internet.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ネットワークエラー',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
                letterSpacing: -0.24,
              ),
            ),
            const SizedBox(height: 17),
            const Text(
              'お手数ですが電波の良い場所で\n再度読み込みをお願いします',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF828282),
                height: 2,
              ),
            ),
            SizedBox(height: deviceHeight * 0.28),
            SizedBox(
              width: deviceWidth * 0.85,
              height: deviceHeight * 0.07,
              child: CustomButton(
                onPressed: onPressed,
                text: '再読み込みする',
                colors: 0xFF74C13A,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
