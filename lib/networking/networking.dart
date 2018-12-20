import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:system_flutter/enums.dart';
import 'dart:convert';
import 'package:system_flutter/models/post.dart';
import 'package:system_flutter/models/automatedpost.dart';
import 'package:connectivity/connectivity.dart';


class NetworkingPage extends StatefulWidget{

  @override
  State createState() {
    return NetworkingState();
  }
}

class NetworkingState extends State<NetworkingPage>{

  final TextStyle stringData = TextStyle(color: Colors.black54);
  var _downloadActive = false;
  var postIdx = 1;
  var _dataStr = DataString(ContentTypes.Placeholder, "Sample JSON not downloaded yet");
  var responseContent;
  var subscription;
  var _networkAvaliable = false;
  PostData postData;


  @override
  void initState() {
    _checkConnectivity();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _checkConnectivity(result: result);
    });
    super.initState();
  }

  _checkConnectivity({ConnectivityResult result}) async{

    if(result == null){
      result = await Connectivity().checkConnectivity();
    }

    if(result == ConnectivityResult.none){
      setState(() {
        _networkAvaliable = false;
      });
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("No network connection"),
            content: Text("It seems like there is no active network connection. Please connect to wifi or mobile network to use this page."),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
    else{
      setState(() {
        _networkAvaliable = true;
      });
    }
  }

  Widget _getContent(){
    return _downloadActive ? Center(child: CircularProgressIndicator(),) : Text(_dataStr.value, style: stringData,);
  }

  _downloadSampleJSON() async{
    postIdx = (postIdx+1)%100;
    final _downloadResponse = await http.get('https://jsonplaceholder.typicode.com/posts/$postIdx').timeout(Duration(seconds: 7), onTimeout: (){
      setState(() {
        _dataStr.value = "Download failed";
        _dataStr.type = ContentTypes.Placeholder;
        _downloadActive = false;
      });
    });
    if(_downloadResponse != null){
      responseContent = _downloadResponse.body;
    }
    if(responseContent != null) {
      setState(() {
        _dataStr.value = jsonEncode(responseContent);
        _dataStr.type = ContentTypes.ValidJson;
        _downloadActive = false;
      });
    }
  }

  _parseSampleJSON(){
    if(responseContent != null){
      // Manual parsing
      Post p = Post.fromJson(jsonDecode(responseContent));

      //Automated parsing
      postData = AutomatedPost.fromJson(jsonDecode(responseContent));

      setState(() {
        _dataStr.value = postData.toString() + p.toString();
        _dataStr.type = ContentTypes.ParsedJson;
      });
    }
  }

  _sendHttpPostRequest()async {
    final response = await http.post("http://httpbin.org/post", body: _dataStr.value).timeout(Duration(seconds: 7), onTimeout: (){
      setState(() {
        _dataStr.value = "Upload failed";
        _dataStr.type = ContentTypes.Placeholder;
      });
    });

    if(response != null && response.body != null){
      setState(() {
        _dataStr.value = response.body;
        _dataStr.type = ContentTypes.PostResponse;
      });
    }
  }

  bool _isParseable(){
    return _dataStr.type == ContentTypes.ValidJson;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                  onPressed: _networkAvaliable ? (){
                    setState(() {
                      _downloadActive = true;
                    });
                    _downloadSampleJSON();
                  } : null,
                  child: Text("Download JSON")),
            ),
            Expanded(
              child: FlatButton(
                  onPressed: _isParseable() ? _parseSampleJSON : null,
                  child: Text("Parse JSON"),
              ),

            ),
            Expanded(
              child: FlatButton(
                  onPressed: _networkAvaliable ? (){
                    _sendHttpPostRequest();
                  } : null,
                  child: Text("HTTP-Post")),
            )
          ],
        ),
        Expanded(
          child: Container(
            color: Colors.black12,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8.0),
            child: _getContent(),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


}

class DataString{
  ContentTypes _type;
  String _value;

  DataString(this._type, this._value);

  String get value => _value;

  set value(String value) {
    _value = value;
  }

  ContentTypes get type => _type;

  set type(ContentTypes value) {
    _type = value;
  }


}