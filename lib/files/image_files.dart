import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageFilesPage extends StatefulWidget{

  @override
  State createState() {
    return ImageFilesPageState();
  }
}

class ImageFilesPageState extends State<ImageFilesPage>{

  Image pickedImage;
  Image fileImage;

  final _subfolderName = "files";
  final _fileName = "imageFile.png";

  _loadFromFile() async{
    final documentsDir = await getApplicationDocumentsDirectory();
    final directory = Directory("${documentsDir.path}/$_subfolderName");
    if(!await directory.exists()){
      _showNoFileDialog();
      return;
    }
    final file = File("${directory.path}/$_fileName");
    if(!await file.exists()){
      _showNoFileDialog();
      return;
    }

    final bytes = file.readAsBytesSync();


    setState(() {
      fileImage = Image.memory(bytes);
    });

  }

  _showNoFileDialog(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("File does not exist"),
          content: Text("Please pick an image first, it will be saved automatically."),
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

  _writeToFile() async{
    final picked = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = Image.file(picked);
    });

    final documentsDir = await getApplicationDocumentsDirectory();
    final directory = Directory("${documentsDir.path}/$_subfolderName");
    if(!await directory.exists()){
      directory.createSync();
    }
    final file = File("${directory.path}/$_fileName");
    if(!await file.exists()){
      file.createSync();
    }
    file.writeAsBytes(await picked.readAsBytes()).whenComplete((){print("Save complete!");});
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
      pickedImage = null;
      fileImage = null;
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
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Text("Picked image: ", textAlign: TextAlign.start,),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          child: pickedImage,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: Text("File image: ", textAlign: TextAlign.start,),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          child: fileImage,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}