import 'package:flutter/material.dart';
import 'package:system_flutter/camera/camera.dart';
import 'package:system_flutter/cloud_sync/cloud_sync_page.dart';
import 'package:system_flutter/local_notifications/local_notifications_page.dart';
import 'package:system_flutter/networking/networking.dart';
import 'package:system_flutter/push_notifications/push_notifications_page.dart';
import 'package:system_flutter/files/files_page.dart';

void main() => runApp(SystemApp());

class SystemApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System APIs Flutter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent
        )
      ),
      home: SystemHomePage(),
    );
  }
}

class SystemHomePage extends StatefulWidget {

  @override
  _SystemHomePageState createState() => _SystemHomePageState();
}

class _SystemHomePageState extends State<SystemHomePage> {

  final List<DrawerItem> drawerElements = List();
  var _selectedDrawerItem = 0;

  @override
  void initState() {
    final item1 = DrawerItem(
      title: "Networking",
      icon: Icon(Icons.network_wifi),
      target: NetworkingPage()
    );
    drawerElements.add(item1);

    final item2 = DrawerItem(
      title: "Local notifications",
      icon: Icon(Icons.notifications),
      target: LocalNotificationsPage()
    );
    drawerElements.add(item2);

    final item3 = DrawerItem(
      title: "Push notifications",
      icon: Icon(Icons.input),
      target: PushNotificationsPage()
    );
    drawerElements.add(item3);

    final item4 = DrawerItem(
        title: "Files",
        icon: Icon(Icons.insert_drive_file),
        target: NetworkingPage()
    );
    drawerElements.add(item4);

    final item5 = DrawerItem(
        title: "Cloud sync",
        icon: Icon(Icons.cloud),
        target: CloudSyncPage()
    );
    drawerElements.add(item5);

    final item6 = DrawerItem(
        title: "Camera",
        icon: Icon(Icons.camera_alt),
        target: NetworkingPage()
    );
    drawerElements.add(item6);
  }


  Widget _getBody(){
    return drawerElements[_selectedDrawerItem].target;
  }

  _checkForRoutingPages(){

    Widget targetPage;

    switch(_selectedDrawerItem){
      case 3:
        targetPage = FilesPage();
        break;
      case 5:
        targetPage = CameraPage();
        break;
    }
      Navigator.push(context, MaterialPageRoute(builder: (context){return targetPage;}));
      _selectedDrawerItem = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("System APIs"),
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: drawerElements.length + 1,
          itemBuilder: (context, index){
            if(index==0){
              return DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: CircleAvatar(
                          child: Text("ME"),
                          minRadius: 50.0,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            else{
              return ListTile(
                title: Text(drawerElements[index-1].title),
                leading: drawerElements[index-1].icon,
                onTap: (){
                  setState(() {
                    _selectedDrawerItem = index-1;
                    Navigator.pop(context);
                    _checkForRoutingPages();
                  });
                },
                selected: _selectedDrawerItem == index-1,
              );
            }
          },
        ),
      ),
      body: _getBody(),
    );
  }
}

class DrawerItem{
  String title;
  Icon icon;
  Widget target;

  DrawerItem({@required this.title, @required this.icon, @required this.target});
}