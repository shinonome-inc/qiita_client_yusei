import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_modal.dart';
import 'package:flutter_app/components/no_internet_widget.dart';
import 'package:flutter_app/config/modal_text.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/top_page.dart';
import 'package:flutter_app/util/connection_status.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../components/custom_appbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  final TextStyle _textStyle = const TextStyle(
    fontFamily: 'Noto Sans JP',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 20 / 14,
  );

  void _showModal(String title, String content) {
    customModal(
      context,
      Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: _textStyle,
            ),
          ),
        ),
      ),
      title: title,
    );
  }

  VoidCallback? _logOut() {
    print("アクセストークン：$accessToken を削除します");
    deleteAccessToken();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const TopPage()));
    return null;
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    Future(() async {
      await ConnectionStatus.checkConnectivity().then((isConnected) {
        if (isConnected) {
          connectionStatus.interNetConnected = true;
        } else {
          connectionStatus.interNetConnected = false;
        }
      });
    });
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (connectionStatus.interNetConnected) {
      // ネットワーク接続ありの場合のウィジェット
      return Scaffold(
          appBar: const CustomAppBar(title: 'Settings'), body: _buildLists());
    } else {
      // ネットワーク接続なしの場合のウィジェット
      return _buildNoInternetWidget();
    }
  }

  Widget _buildNoInternetWidget() {
    // ネットワークに接続されていない時はNoInterNetWidgetを表示する
    return NoInternetWidget(
      onPressed: () async {
        if (await ConnectionStatus.checkConnectivity()) {
          connectionStatus.interNetConnected = true;
          setState(() {});
        } else {
          connectionStatus.interNetConnected = false;
        }
      },
    );
  }


  Widget _buildLists() {
    if (connectionStatus.interNetConnected) {
      return Scaffold(
        body: Column(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 31.5, left: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'アプリ情報',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildListTile(
                          'プライバシーポリシー',
                          Icons.arrow_forward_ios_rounded,
                              () => _showModal(
                              'プライバシーポリシー', ModalText.privacyPolicyText)),
                      const Divider(height: 1, thickness: 1, indent: 16),
                      _buildListTile(
                          '利用規約',
                          Icons.arrow_forward_ios_rounded,
                              () =>
                              _showModal('利用規約', ModalText.termsOfServiceText)),
                      const Divider(height: 1, thickness: 1, indent: 16),
                      _buildListTile('アプリバージョン', null, null,
                          trailingText: "v${_packageInfo.version}"),
                      const Divider(height: 1, thickness: 1, indent: 16),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: accessToken != '',
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 36, left: 16, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'その他',
                        style: TextStyle(
                          color: Color(0xFF828282),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildListTile(
                          'ログアウトする',
                          null,
                              () => _logOut(),
                        ),
                        const Divider(height: 1, thickness: 1, indent: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return _buildNoInternetWidget();
    }
  }

  Widget _buildListTile(String title, IconData? iconData, VoidCallback? onTap,
      {String? trailingText}) {
    return SizedBox(
      height: 40,
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                title,
                style: _textStyle,
              ),
            ),
            if (iconData != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  iconData,
                  color: const Color(0xFF333333),
                ),
              )
            else if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  trailingText,
                  style: _textStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
