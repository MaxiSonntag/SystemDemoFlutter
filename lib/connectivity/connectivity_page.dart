import 'package:flutter/material.dart';
import 'package:system_flutter/connectivity/bluetooth_page.dart';

class ConnectivityPage extends StatefulWidget{

  @override
  State createState() {
    return ConnectivityPageState();
  }
}

class ConnectivityPageState extends State<ConnectivityPage>{

  var _currentIndex = 0;


  Widget getBody(){
    if(this._currentIndex == 0){
      return BluetoothPage();
    }
    return Container(color: Colors.purple,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            title: Text("Bluetooth")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nfc),
            title: Text("NFC")
          )
        ],
        currentIndex: this._currentIndex,
        onTap: (idx){
          setState(() {
            this._currentIndex = idx;
          });
        },
      ),
      body: getBody(),
    );
  }
}