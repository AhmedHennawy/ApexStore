import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/HomePage.dart';
import './screens/StartScreen.dart';

Future<void>  main() async {
  //WidgetsFlutterBinding.ensureInitialized();
   //FlutterDownloader.initialize(
      //debug: true
  //);
  //await Permission.storage.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FasterTime',
      debugShowCheckedModeBanner: false,
      home: StartSreen(),
    );
  }
  
}
