import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class CameraScanPage extends StatefulWidget {
  @override
  State createState() {
    return CameraScanPageState();
  }
}

class CameraScanPageState extends State<CameraScanPage> {
  String _result = "";

  Future _scanCode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this._result = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._result = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this._result = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this._result =
          'null (User returned using the "back"-button before scanning anything.)');
    } catch (e) {
      setState(() => this._result = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(_result, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold), softWrap: true, textAlign: TextAlign.center,),
            ),
          ),
          FlatButton(onPressed: _scanCode, child: Text("Scan code")),

        ],
      ),
    );
  }
}
