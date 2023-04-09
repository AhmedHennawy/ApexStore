// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoad = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
            children: <Widget>[
              WebView(
                initialUrl: 'https://login.erp-apex.com/login',
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (finish) {
                  setState(() {
                    isLoad = false;
                  });
                },
              ),
              isLoad
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(),
            ],
        ),
      ),
    );
  }
}
