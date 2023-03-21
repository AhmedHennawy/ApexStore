// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoad = true;
  //String url = 'https://erp.apex-program.com/';
  late InAppWebViewController  _controller;


  @override
  void initState() {
    super.initState();
    

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
            children: <Widget>[
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse('https://erp.apex-program.com/')), 

                initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          useOnDownloadStart: true
                      ),
                    ),

                 onWebViewCreated: (InAppWebViewController controller) {
                      _controller = controller;
                    },
                
                onDownloadStartRequest: (controller, url) async {
                      print(url.toString());
                      final taskId = await FlutterDownloader.enqueue(
                        url: "$url",
                        savedDir: (await getExternalStorageDirectory())!.path,
                        showNotification: true, // show download progress in status bar (for Android)
                        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                        saveInPublicStorage: true,
                      );
                    },
                 
              ),
             
            ],
        ),
      ),
    );
  }
}
