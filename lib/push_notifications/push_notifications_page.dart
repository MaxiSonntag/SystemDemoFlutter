import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'guide_item.dart';


class PushNotificationsPage extends StatefulWidget{

  @override
  State createState() {
    return PushNotificationsState();
  }
}

class PushNotificationsState extends State<PushNotificationsPage>{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<List<String>> guideInfos = List<List<String>>();

  @override
  void initState() {
    if(!Platform.isIOS){
      firebaseCloudMessagingListeners();
    }
    _setupGuideItems();

    super.initState();
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token){
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("ON MESSAGE: $message");
        _showPushDialog(_getPushMessageString(message));
      },
      onResume: (Map<String, dynamic> message) async {
        print("ON RESUME: $message");
        _showPushDialog(_getPushMessageString(message));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("ON LAUNCH: $message");
        _showPushDialog(_getPushMessageString(message));
      },
    );
  }

  _getPushMessageString(Map<String, dynamic> message){
    final notification = message["notification"];
    final title = notification["title"];
    final body = notification["body"];
    return "$title \n $body";
  }

  _showPushDialog(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Push Notification received!"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Cool!"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  _setupGuideItems(){
    _addToGuideInfo(
      title: "Login",
      description: "",
      imageName: "login"
    );

    _addToGuideInfo(
      title: "Console & Project",
      description: "Navigate to the Firebase Console and select the Project 'Cross-Platform Demo'.",
      imageName: "project"
    );

    _addToGuideInfo(
        title: "Cloud Messaging",
        description: "Select 'Cloud Messaging' in the Side Drawer.",
        imageName: "cloud"
    );

    _addToGuideInfo(
        title: "Select Duplicate",
        description: "Click on 'Duplikat' on the existing notification.",
        imageName: "duplicate"
    );

    _addToGuideInfo(
        title: "Send notification",
        description: "Click on 'Überprüfung'. In the opened window, click 'Veröffentlichen'. Your Android decive should now receive a notification.",
        imageName: "publish"
    );

    _addToGuideInfo(
        title: "App in background",
        description: "If your app was in background, you should see a notification in the notification bar.",
        imageName: "push"
    );

    _addToGuideInfo(
        title: "App in foreground",
        description: "If your app was in foreground and on this screen, you should see an alert dialog.",
        imageName: "alert"
    );

  }

  _addToGuideInfo({String title, String description, String imageName}){
    final infos = List<String>();
    infos.add(title);
    infos.add(description);
    infos.add(imageName);
    this.guideInfos.add(infos);
  }

  @override
  Widget build(BuildContext context) {

    return _getContent();
  }

  Widget _getContent(){
    if(Platform.isAndroid){
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: guideInfos.length,
        itemBuilder: (context, index){
          return Column(
            children: <Widget>[
              GuideItem(
                  step: index+1,
                  title: guideInfos[index][0],
                  description: guideInfos[index][1],
                  imageName: guideInfos[index][2]
              ),
              Divider()
            ],
          );
        },
      );
    }
    return Center(
      child: Text("Please use an Android device to test this feature"),
    );
  }
}