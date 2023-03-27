import 'package:flutter/material.dart';

Future<void> customModal(BuildContext context, Widget child) async {
  await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 11),
            alignment: Alignment.bottomCenter,
            height: 59,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(249, 249, 249, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: const Text(
              'Article',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Pacifico', fontSize: 17),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    ),
  );
}
