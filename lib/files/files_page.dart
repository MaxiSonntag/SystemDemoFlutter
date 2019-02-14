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

  int _currentIdx = 0;
  List<Widget> _pages = [TextFilesPage(), ImageFilesPage()];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text("Text"),
            icon: Icon(Icons.text_fields)
          ),
          BottomNavigationBarItem(
            title: Text("Images"),
            icon: Icon(Icons.image)
          )
        ],
        onTap: (idx){
          setState(() {
            _currentIdx = idx;
          });
        },
        currentIndex: _currentIdx,
      ),
      body: _pages[_currentIdx],
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