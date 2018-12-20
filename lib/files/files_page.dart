import 'package:flutter/material.dart';
import 'package:system_flutter/files/image_files.dart';
import 'text_files.dart';

class FilesPage extends StatefulWidget{


  @override
  State createState() {
    return FilesPageState();
  }
}

class FilesPageState extends State<FilesPage>{


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Filesystem"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Text",
              ),
              Tab(
                text: "Images",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TextFilesPage(),
            ImageFilesPage()
          ],
        ),
      ),
    );
  }
}

/*
Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){return TextFilesPage();}));},
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 2
                      )
                  ),
                  child: Center(
                    child: Text("Text", style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){return TextFilesPage();}));},
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 2
                      )
                  ),
                  child: Center(
                    child: Text("Images", style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ),
              ),
            ),
          )
        ],
      )
 */