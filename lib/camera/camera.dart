import 'package:flutter/material.dart';
import 'package:system_flutter/camera/camera_scan.dart';
import 'simple_camera.dart';

class CameraPage extends StatefulWidget {
  @override
  State createState() {
    return CameraPageState();
  }
}

class CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Camera usage"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                icon: Icon(Icons.code),
              ),
              Tab(
                icon: Icon(Icons.threed_rotation),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SimpleCameraPage(),
            CameraScanPage(),
            Container(
              child: Center(
                child: Text("AR is currently not supported with Flutter", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center , softWrap: true,)
              ),
            )
          ],
        ),
      ),
    );
  }
}
