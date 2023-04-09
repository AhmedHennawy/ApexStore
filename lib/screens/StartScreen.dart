// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../screens/HomePage.dart';

class StartSreen extends StatefulWidget {
  const StartSreen({Key? key}) : super(key: key);

  @override
  State<StartSreen> createState() => _StartSreenState();
}

class _StartSreenState extends State<StartSreen> {

  final asset = 'assets/splashvidwp.mp4';
  late VideoPlayerController videoController;
   Future<void>? _initVideo;
  
  @override 
  void initState() {

    super.initState();

    try{
      //'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
       videoController =  VideoPlayerController.asset(asset)
      ..initialize().then((_){
        videoController.addListener(checkVideo);
        setState(() {
          videoController.play();
        });
      });

    var x = videoController.value.isInitialized;
    print(x);
    }catch(ex){
      print(ex.toString());
    }

  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:videoController.value.isInitialized ? Container(
        height: double.infinity,
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: videoController.value.aspectRatio,
          child: VideoPlayer(videoController)),
      ) : Container(),
        
      
    );
  }

  void checkVideo() {
    if(videoController.value.position == videoController.value.duration){
       Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }
}