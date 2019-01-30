import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:flutter/services.dart';

class NFCPage extends StatefulWidget{

  @override
  State createState() {
    return NFCPageState();
  }
}

class NFCPageState extends State<NFCPage>{

  bool isReading = false;
  String nfcValue = "";


  startReading() async{
    NfcData response;
    setState(() {
      isReading = true;
    });

    try {
      response = await FlutterNfcReader.read;
      print("RESPONSE: $response");
    } on PlatformException {
      response = NfcData(id: "ERROR", content: "PLATFORM EXCEPTION", error: "PLATFORM EXCEPTION");

    }

    if(response.statusMapper == "error"){
      showNFCDisabledDialog();
    }


    setState(() {
      isReading = false;
      nfcValue = "ID: ${response.id}\nCONTENT: ${response.content}\nSTATUS: ${response.statusMapper}\nERROR: ${response.error}";
      print(nfcValue);
    });
  }

  showNFCDisabledDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Enable NFC"),
            content: Text("NFC is currently disabled. Please enable it to use this feature."),
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

  stopReading() async{
    bool response;
    try {
      final NfcData result = await FlutterNfcReader.stop;
      response = true;
    } on PlatformException {
      response = false;
    }
    setState(() {
      print("STOPPED: $response");
      isReading = !response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                child: Text("Read"),
                onPressed: isReading ? null : startReading,
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Text("Stop"),
                onPressed: isReading ? stopReading : null,
              )
            )
          ],
        ),
        Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Text("Currently scanning: $isReading"),
              ),
              Text(nfcValue)
            ],
          ),
        )
      ],
    );
  }
}