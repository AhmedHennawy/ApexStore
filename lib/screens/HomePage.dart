import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
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
  late InAppWebViewController _controller;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    //_unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse('https://erp.apex-program.com/')),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(useOnDownloadStart: true),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _controller = controller;
              },
              onDownloadStartRequest: (controller, url) async {
                print(url.toString());
                var dir = await _getDirectoryPath();


                try {
                  final taskId = await FlutterDownloader.enqueue(
                    url: url.url.toString(),
                    savedDir: dir!,
                    showNotification: true, // show download progress in status bar (for Android)
                    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                    saveInPublicStorage: true,
                  );
                } catch (ex) {
                  throw ex;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getDirectoryPath() async {
    String? dir;
    if (Platform.isAndroid) {
      try {
        dir = await PathProviderAndroid().getDownloadsPath();
      } catch (e) {
        dir = (await getExternalStorageDirectory())!.path;
      }
    } else if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).absolute.path;
    }

    final saveDir = Directory(dir!);
    bool exist = await saveDir.exists();
    if (!exist) saveDir.create();

    return dir;
  }

  void _bindBackgroundIsolate() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
}
