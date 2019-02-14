import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter/services.dart';
import 'package:system_flutter/enums.dart';

class LocationPage extends StatefulWidget {
  @override
  State createState() {
    return LocationPageState();
  }
}

class LocationPageState extends State<LocationPage> {
  Map<String, double> _currentLocation;

  var location = Location();

  StreamSubscription listener;
  var _isListening = false;

  _beginLocationTracking() async {
    var _successful = false;
    if (listener == null) {
      _successful = await _startLocationTracking();
    } else {
      listener.resume();
      _successful = true;
    }
    setState(() {
      _isListening = _successful;
    });
  }

  _stopLocationTracking() {
    listener.pause();
    setState(() {
      _isListening = false;
      location = null;
    });
  }

  Future<bool> _startLocationTracking() async {
    try {
      if(Theme.of(context).platform == TargetPlatform.iOS){
        var granted = await _checkPermission();
        print("Permissions granted: $granted");
      }
      _currentLocation = await location.getLocation().timeout(Duration(seconds: 3), onTimeout: (){
        //throw PlatformException(code: "BT_DISABLED");
      });
      //}

      listener =
          location.onLocationChanged().listen((Map<String, double> data) {
        setState(() {
          _currentLocation = data;
          print("LISTENER: $_currentLocation");
        });
      });
    } on PlatformException catch (e) {
      print("ERROR: $e");
      if (e.code == 'PERMISSION_DENIED') {
        _showInfoDialog(DialogType.GPSPermission);
      } else {
        _showInfoDialog(DialogType.GPSEnabled);
      }
      return false;
    }

    return true;
  }

  Future<bool> _checkPermission() async {
    var _permissionGranted = await location.hasPermission();
    print("PERMISSION: $_permissionGranted");
    /*return _permissionGranted;*/

    var isGranted = false;
    isGranted =
        await SimplePermissions.checkPermission(Permission.AccessFineLocation);

    if (!isGranted) {
      var _status = await SimplePermissions.requestPermission(
          Permission.AccessFineLocation);
      isGranted = _status == PermissionStatus.authorized;
    }
    return isGranted;
  }

  _showInfoDialog(DialogType type) {
    var title;
    var message;
    if (type == DialogType.GPSPermission) {
      title = "Permission denied";
      message = "Please allow GPS usage for this app in your settings";
    } else if (type == DialogType.GPSEnabled) {
      title = "Error";
      message =
          "Something went wrong. Your GPS might be disabled, enable it and try again.";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  String _getTextForField(String field) {
    if (_currentLocation == null || _currentLocation[field] == null) {
      return "";
    }
    return _currentLocation[field].toString();
  }

  testTracking() async {
    final loc = await location.getLocation();
    setState(() {
      _currentLocation = loc;
      print("Location: $loc");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Text("Start tracking"),
                  onPressed:
                      _isListening ? null : () => _beginLocationTracking(),
                ),
              ),
              Expanded(
                child: FlatButton(
                  child: Text("Stop tracking"),
                  onPressed:
                      _isListening ? () => _stopLocationTracking() : null,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Latitude: " + _getTextForField("latitude")),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Longitude: " + _getTextForField("longitude")),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Accuracy: " + _getTextForField("accuracy")),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Altitude: " + _getTextForField("altitude")),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Speed: " + _getTextForField("speed")),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (listener != null) {
      listener.cancel();
    }
  }
}
