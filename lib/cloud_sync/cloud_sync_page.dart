import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudSyncPage extends StatefulWidget {
  @override
  State createState() {
    return CloudSyncState();
  }
}

class CloudSyncState extends State<CloudSyncPage> {
  final textFieldCtrl = TextEditingController();
  final contentStyle = TextStyle(color: Colors.black54);

  final collectionName = "example";
  final documentName = "example_doc";
  final fieldName = "example_field";
  final timestampFieldName = "timestamp";

  String cloudDataText = "";
  Timestamp localDataTimestamp;
  Timestamp cloudDataTimestamp;

  @override
  void initState() {
    print("INIT STATE CALLED");

    if (Platform.isAndroid) {
      Firestore.instance.settings(timestampsInSnapshotsEnabled: true);


      Firestore.instance.collection(collectionName).snapshots().listen((data) {
        final newest = data.documents.last;
        print(newest[fieldName]);
        print("Local: $localDataTimestamp");
        print("Cloud: ${newest[timestampFieldName]}");

        final serverTimestamp = newest[timestampFieldName] as int;
        if (newest[timestampFieldName] == null || (localDataTimestamp == null ||
            serverTimestamp >=
                localDataTimestamp.millisecondsSinceEpoch) ) {
          setState(() {
            cloudDataText = newest[fieldName];
            localDataTimestamp = Timestamp.fromMillisecondsSinceEpoch(serverTimestamp);
          });
        }
      });
    }

    super.initState();
  }

  _uploadTextFieldValue() async {
    print("UPLOAD CALLED");

    localDataTimestamp = Timestamp.now();
    try {
      await Firestore.instance
          .collection(collectionName)
          .document(documentName)
          .setData({
        fieldName: '${textFieldCtrl.text}',
        timestampFieldName: localDataTimestamp.millisecondsSinceEpoch
      });
    } catch (e) {
      print("Upload: Permission denied because local data is older than server data");
    }
  }

  Widget _getBody() {
    if (Platform.isAndroid) {
      return Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Enter some text and upload it"),
                    controller: textFieldCtrl,
                  ),
                ),
                FlatButton(
                  child: Text("Upload"),
                  onPressed: _uploadTextFieldValue,
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 16.0),
                padding: EdgeInsets.all(8.0),
                color: Colors.black12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Cloud data:",
                      style: contentStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    Text(
                      cloudDataText,
                      style: contentStyle,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    return Center(
      child: Text("Please use an Android device to test this feature."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }
}
