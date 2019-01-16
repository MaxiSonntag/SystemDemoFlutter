import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:system_flutter/enums.dart';

class BluetoothPage extends StatefulWidget {
  @override
  State createState() {
    return BluetoothPageState();
  }
}

class BluetoothPageState extends State<BluetoothPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> subscription;
  Map<int, StreamSubscription<BluetoothDeviceState>> deviceConnections = Map();
  var isScanning = false;
  List<ScanResult> foundDevices = new List();
  var _isFirstScan = true;

  Map<int, BluetoothDeviceState> connectionStates = Map();

  Widget getBody() {
    if (isScanning) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
        itemCount: foundDevices.length,
        itemBuilder: (context, index) {
          final device = foundDevices[index].device;
          return ListTile(
            title: device.name.isNotEmpty
                ? Text(device.name)
                : Text("No name provided"),
            subtitle: Text(device.id.id),
            trailing: FlatButton(
                onPressed: ()=>_toggleConnection(index),
                child: _getConnectBtnText(index)
            ),
            leading: _getConnectionIndicator(index),
          );
        });
  }

  Widget _getConnectBtnText(int index){
    if(connectionStates.containsKey(index)){
      final state = connectionStates[index];
      if(state == BluetoothDeviceState.connected || state == BluetoothDeviceState.connecting){
        return Text("Disconnect");
      }
    }
    return Text("Connect");
  }

  Widget _getConnectionIndicator(int index){
    if(connectionStates.containsKey(index)){
      Color color;
      if(_isConnectedOrConnecting(index)){
        color = Colors.green;
      }
      else{
        color = Colors.red;
      }
      return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        margin: EdgeInsets.only(left: 18),
      );
    }
  }

  _scan() async {
    print("SCAN CALLED");
    if(!await flutterBlue.isAvailable || !await flutterBlue.isOn){
      showInfoDialog(DialogType.BT);
      return;
    }
    if(_isFirstScan){
      showInfoDialog(DialogType.Info);
      _isFirstScan = false;
    }

    this.isScanning = true;
    this.deviceConnections.clear();
    this.connectionStates.clear();
    subscription = flutterBlue.scan().listen((scanResult) {
      //print(scanResult.device.id.id);
      if (foundDevices
              .where((dev) => dev.device.id.id == scanResult.device.id.id)
              .length == 0) {
        foundDevices.add(scanResult);
      } else {
        foundDevices
            .removeWhere((dev) => dev.device.id.id == scanResult.device.id.id);
        foundDevices.add(scanResult);
      }
      setState(() {});
    });

    Future.delayed(Duration(seconds: 4), () {
      _stopScan();
    });
  }

  showInfoDialog(DialogType type){
    String title;
    String content;

    switch(type){
      case DialogType.BT:{
        title = "Enable Bluetooth";
        content = "Please enable Bluetooth to check out this feature.";
        break;
      }
      case DialogType.Info:{
        title = "Info";
        content = "This plugin only supports Bluetooth LE. If there is no BT LE device near you, you will possibly see several unnamed networks, like Wifi or Bluetooth Classic devices. If connection succeeds, you may see the devices name the next time you scan. (iOS only)";
      }
    }


    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: ()=>Navigator.pop(context),
              )
            ],
          );
      }
    );
  }

  _stopScan() {
    setState(() {
      this.isScanning = false;
    });
    subscription.cancel();
  }

  _toggleConnection(int index){
    if(connectionStates.containsKey(index)){
      if(!_isConnectedOrConnecting(index)){
        _connect(index);
      }
      else{
        _disconnect(index);
      }
    }
    else{
      _connect(index);
    }

  }

  _connect(int index){
    deviceConnections[index] = flutterBlue.connect(foundDevices[index].device).listen((deviceState){
      setState(() {
        connectionStates[index] = deviceState;
      });
    });
  }

  _disconnect(int index){
    setState(() {
      deviceConnections[index].cancel();
      deviceConnections.remove(index);
      connectionStates[index] = BluetoothDeviceState.disconnected;
      print("Disconnected");
    });
  }

  bool _isConnectedOrConnecting(index){
    final state = connectionStates[index];
    if(state == BluetoothDeviceState.connecting || state == BluetoothDeviceState.connected){
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    deviceConnections.forEach((idx, conn){
      conn.cancel();
    });
    if(subscription != null){
      subscription.cancel();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                child: Text("Scan"),
                onPressed: isScanning ? null : _scan,
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Text("Stop"),
                onPressed: isScanning ? _stopScan : null,
              ),
            )
          ],
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("Found devices: "),
                color: Colors.black12,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
              ),
              Expanded(
                child: getBody(),
              )
            ],
          ),
        )
      ],
    );
  }
}
