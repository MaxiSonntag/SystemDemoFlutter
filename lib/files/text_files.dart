import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TextFilesPage extends StatefulWidget {
  @override
  State createState() {
    return TextFilesPageState();
  }
}

class TextFilesPageState extends State<TextFilesPage> {
  TextEditingController _textFieldCtrl = new TextEditingController();
  var outputText = "";
  final noFileText= "File does not exist, please write to file before reading.";
  final _subfolderName = "files";
  final _fileName = "textFile.txt";


  @override
  void initState() {
    outputText = noFileText;
    _loadFromFile();
  }

  _writeToFile() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final subfolder = Directory("${documentsDir.path}/$_subfolderName");
    if(!await subfolder.exists()){
      subfolder.createSync();
    }
    final file = File("${subfolder.path}/$_fileName");
    if(!await file.exists()){
      file.createSync();
    }
    file.writeAsString(_textFieldCtrl.text);
  }

  _loadFromFile() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final subfolder = Directory("${documentsDir.path}/$_subfolderName");
    if(!await subfolder.exists()){
      return;
    }
    final file = File("${subfolder.path}/$_fileName");
    if(await file.exists()){
      var content = await file.readAsString();
      if(content.isEmpty){
        content = "The file exists but is empty!";
      }
      setState(() {
        outputText = "${file.path}\n\n$content";
      });
    }
    else{
      setState(() {
        outputText = noFileText;
      });
    }
  }

  _deleteFile() async{
    final documentsDir = await getApplicationDocumentsDirectory();
    final subfolder = Directory("${documentsDir.path}/$_subfolderName");
    if(!await subfolder.exists()){
      return;
    }
    final file = File("${subfolder.path}/$_fileName");
    if(await file.exists()){
      file.delete();
      subfolder.delete();
    }
    setState(() {
      outputText = noFileText;
    });
  }


  Widget _getButtonRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: FlatButton(
            child: Text("Load"),
            onPressed: _loadFromFile,
          ),
        ),
        Expanded(
          child: FlatButton(
            child: Text("Write"),
            onPressed: _writeToFile,
          ),
        ),
        Expanded(
          child: FlatButton(
            child: Text("Delete"),
            onPressed: _deleteFile,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getButtonRow(),
          TextField(
            controller: _textFieldCtrl,
            decoration: InputDecoration(labelText: "Enter some text"),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: Text("File content: ", textAlign: TextAlign.start,),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            color: Colors.black12,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8.0),
            child: Text(
              outputText,
              style: TextStyle(color: Colors.black54),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
