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

  int _currentIdx = 0;
  List<Widget> _pages = [SimpleCameraPage(), CameraScanPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text("Camera"),
            icon: Icon(Icons.camera_alt)
          ),
          BottomNavigationBarItem(
            title: Text("QR-Code"),
            icon: Icon(Icons.code)
          )
        ],
        currentIndex: _currentIdx,
        onTap: (idx){
          setState(() {
            _currentIdx = idx;
          });
        },
      ),
      body: _pages[_currentIdx],
    );
  }
}
