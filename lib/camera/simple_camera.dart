import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:system_flutter/camera/media_viewer.dart';
import 'package:system_flutter/enums.dart';

class SimpleCameraPage extends StatefulWidget {
  @override
  State createState() {
    return SimpleCameraPageState();
  }
}

class SimpleCameraPageState extends State<SimpleCameraPage> {
  List<CameraDescription> cameras;
  CameraController camCtrl;
  int _radioValue;
  String _filePath = "";
  RecordedMedia media;

  @override
  void initState() {
    super.initState();
    availableCameras().then((available) {
      this.cameras = available;
    });
  }

  @override
  void dispose() {
    camCtrl?.dispose();
    getApplicationDocumentsDirectory().then((dir) {
      final imageDirPath = '${dir.path}/camera/images';
      final imageDir = Directory(imageDirPath);
      imageDir.exists().then((exists) {
        if (exists) {
          imageDir.delete(recursive: true);
        }
      });

      final videoDirPath = '${dir.path}/camera/videos';
      final videoDir = Directory(videoDirPath);
      videoDir.exists().then((exists) {
        if (exists) {
          videoDir.delete(recursive: true);
        }
      });
    });
    super.dispose();
  }

  Widget getCamera() {
    if (camCtrl == null || !camCtrl.value.isInitialized) {
      return Container(
        child: Center(
          child: Text(
            "Please pick a camera",
            softWrap: true,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: camCtrl.value.aspectRatio,
      child: CameraPreview(camCtrl),
    );
  }

  void _onRadioChanged(int val) {
    setState(() {
      _radioValue = val;

      _getDesiredCamera().then((ctrl) {
        camCtrl = ctrl;
        camCtrl.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        },
        onError: (e){
          print("Camera Error: $e");
          showDialog(
              context: context,
            builder: (context){
                return AlertDialog(
                  title: Text("Permission denied"),
                  content: Text("You need to grant permission for camera usage."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
            }
          );
        });
      });
    });
  }

  Future<CameraController> _getDesiredCamera() async {
    if (camCtrl != null) {
      await camCtrl.dispose();
    }
    if (cameras.length >= _radioValue) {
      return CameraController(cameras[_radioValue], ResolutionPreset.medium);
    }
  }

  Future<Directory> _getDirectory(bool isVideo) async {
    final docDir = await getApplicationDocumentsDirectory();
    var subDir = "images";
    if (isVideo) {
      subDir = "videos";
    }
    final dirPath = '${docDir.path}/camera/$subDir';
    return await Directory(dirPath).create(recursive: true);
  }

  String timestamp() {
    return new DateTime.now().millisecondsSinceEpoch.toString();
  }

  _takePicture() async {
    final timestamp = this.timestamp();
    final dir = await _getDirectory(false);
    final filePath = '${dir.path}/$timestamp.jpg';
    if (camCtrl.value.isTakingPicture) {
      return;
    }
    await camCtrl.takePicture(filePath);
    setState(() {
      _filePath = filePath;
      media = RecordedMedia(filePath, CameraMediaTypes.Image);
    });
  }

  Widget getThumbnail() {
    if (_filePath.isEmpty ||
        camCtrl == null ||
        camCtrl.value.isRecordingVideo) {
      return null;
    }
    return GestureDetector(
      child: Container(
        height: 64.0,
        child: getMediaPreview(),
      ),
      onTap: _openMedia,
    );
  }

  getMediaPreview() {
    if (media.type == CameraMediaTypes.Image) {
      return Image.file(File(_filePath), fit: BoxFit.contain, height: 64.0);
    }
    return Icon(Icons.play_circle_filled);
  }

  _openMedia() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MediaViewer(
                  media: media,
                )));
  }

  _startRecording() async {
    final timestamp = this.timestamp();
    final dir = await _getDirectory(true);
    final filePath = '${dir.path}/$timestamp.mp4';
    await camCtrl.startVideoRecording(filePath);

    setState(() {
      _filePath = filePath;
      media = RecordedMedia(filePath, CameraMediaTypes.Video);
    });
  }

  _stopRecording() async {
    if (camCtrl.value.isRecordingVideo) {
      await camCtrl.stopVideoRecording();
      setState(() {});
    }
  }

  bool _isCameraUsable() {
    return camCtrl != null &&
        camCtrl.value.isInitialized &&
        !camCtrl.value.isRecordingVideo &&
        !camCtrl.value.isTakingPicture;
  }

  bool _isVideoStoppable() {
    return camCtrl != null &&
        camCtrl.value.isInitialized &&
        camCtrl.value.isRecordingVideo;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: getCamera(),
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _isCameraUsable() ? _takePicture : null,
                    color: Theme.of(context).primaryColor,
                    disabledColor: Colors.black54,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.videocam),
                    onPressed: _isCameraUsable() ? _startRecording : null,
                    color: Theme.of(context).primaryColor,
                    disabledColor: Colors.black54,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: _isVideoStoppable() ? _stopRecording : null,
                    color: Colors.red,
                    disabledColor: Colors.black54,
                  ),
                ),
              ],
            ),
            Container(
              height: 64.0,
              child: Row(
                children: <Widget>[
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _onRadioChanged),
                  Icon(Icons.camera_rear),
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _onRadioChanged),
                  Icon(Icons.camera_front),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 3.0, right: 8.0),
                      alignment: Alignment.centerRight,
                      child: getThumbnail(),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class RecordedMedia {
  String file;
  CameraMediaTypes type;

  RecordedMedia(String filePath, this.type) {
    this.file = filePath;
  }
}
