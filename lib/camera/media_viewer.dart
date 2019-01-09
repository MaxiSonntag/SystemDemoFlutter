import 'dart:io';
import 'package:flutter/material.dart';
import 'simple_camera.dart';
import 'package:system_flutter/enums.dart';
import 'package:video_player/video_player.dart';

class MediaViewer extends StatefulWidget {
  final RecordedMedia media;

  MediaViewer({@required this.media});

  @override
  State createState() {
    return MediaViewerState();
  }
}

class MediaViewerState extends State<MediaViewer> {
  RecordedMedia media;
  VideoPlayerController videoCtrl;

  @override
  void initState() {
    super.initState();
    this.media = widget.media;

    videoCtrl = VideoPlayerController.file(File(media.file))
      ..initialize().then((_) {
        setState(() {});
        videoCtrl.setLooping(true);
        videoCtrl.play();
      });
  }

  @override
  void dispose() {
    videoCtrl?.dispose();
    super.dispose();
  }

  getViewer() {
    if (media.type == CameraMediaTypes.Image) {
      return Image.file(File(media.file), fit: BoxFit.contain);
    }
    return VideoPlayer(videoCtrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media"),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: getViewer(),
      ),
    );
  }
}
