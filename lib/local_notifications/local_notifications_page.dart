import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class LocalNotificationsPage extends StatefulWidget {
  @override
  State createState() {
    return LocalNotificationsState();
  }
}

class LocalNotificationsState extends State<LocalNotificationsPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_stat_name');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String notification) async {
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Notification tapped"),
            content: Text("Try out the other notifications"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                "If using on older iOS, be sure to put the app in the background. You won't receive local notifications otherwise.",
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Flexible(
              child: FlatButton(
                  child: Text('Send simple notification'),
                  onPressed: _showNotification),
            ),
            Flexible(
              child: FlatButton(
                  child: Text('Send colored notification'),
                  onPressed: _showColoredNotification),
            ),
            Flexible(
              child: FlatButton(
                  child: Text('Send grouped notification'),
                  onPressed: _sendGroupedNotification),
            ),
            Flexible(
              child: FlatButton(
                  child: Text('Send image notification'),
                  onPressed: _sendImageNotification),
            ),
          ],
        ));
  }

  _showNotification() {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'simple_channel_id',
      'channel_simple_notification',
      'channel for simple notifications',
      importance: Importance.High,
      priority: Priority.Max,

    );

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(0, 'Simple Notification',
        'Not really spectacular', platformChannelSpecifics,
        payload: 'simple');
  }

  _showColoredNotification() {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'colored_channel_id',
      'channel_colored_notification',
      'channel for colored notifications',
      importance: Importance.High,
      priority: Priority.Max,
      color: Colors.green,
    );

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(1, 'Colored Notification',
        'This one has some color', platformChannelSpecifics,
        payload: 'colored');
  }

  _sendGroupedNotification() async {
    if (Platform.isIOS) {
      _showAlertUnavailableOnIOS();
      return;
    }
    final groupKey = 'group_key';
    final groupChannelId = 'grouped_channel_id';
    final groupChannelName = 'channel_grouped_notification';
    final groupChannelDescription = 'channel for grouped notifications';
    final firstMessageTitle = "Grouped Notification 1";
    final firstMessage = "This one can be grouped";
    final secondMessageTitle = "Grouped Notification 2";
    final secondMessage = "This one can also be grouped";

    final firstNotificationAndroidSpecifics = new AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      groupKey: groupKey,
    );
    final firstNotificationPlatformSpecifics =
        new NotificationDetails(firstNotificationAndroidSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        1, firstMessageTitle, firstMessage, firstNotificationPlatformSpecifics,
        payload: "grouped1");

    final secondNotificationAndroidSpecifics = new AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      groupKey: groupKey,
    );

    final secondNotificationPlatformSpecifics =
        new NotificationDetails(secondNotificationAndroidSpecifics, null);
    await flutterLocalNotificationsPlugin.show(2, secondMessageTitle,
        secondMessage, secondNotificationPlatformSpecifics,
      payload: "grouped2"
    );

    final lines = new List<String>();
    lines.add(firstMessageTitle + " " + firstMessage);
    lines.add(secondMessageTitle + " " + secondMessage);
    final inboxStyleInformation = new InboxStyleInformation(lines,
        contentTitle: 'New grouped Notifications', summaryText: 'Grouped notifications');
    final androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      style: AndroidNotificationStyle.Inbox,
      styleInformation: inboxStyleInformation,
      groupKey: groupKey,
      setAsGroupSummary: true,
    );
    final platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two new messages', platformChannelSpecifics, payload: "grouped_summary");
  }

  _sendImageNotification() async {
    if (Platform.isIOS) {
      _showAlertUnavailableOnIOS();
      return;
    }
    final directory = await getApplicationDocumentsDirectory();
    final largeIconResponse =
        await http.get('https://picsum.photos/50/?random"');
    final largeIconPath = '${directory.path}/largeIcon';
    var file = new File(largeIconPath);
    await file.writeAsBytes(largeIconResponse.bodyBytes);

    final bigPictureResponse =
        await http.get('https://picsum.photos/300/?random"');
    final bigPicturePath = '${directory.path}/bigPicture';
    file = new File(bigPicturePath);
    await file.writeAsBytes(bigPictureResponse.bodyBytes);

    final bigPictureStyleInformation = new BigPictureStyleInformation(
        bigPicturePath, BitmapSource.FilePath,
        largeIcon: largeIconPath,
        largeIconBitmapSource: BitmapSource.FilePath,
        contentTitle: 'Image Notification',
        summaryText: 'This one even has an image!');

    final androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'image_channel_id',
        'channel_image_notification',
        'channel for image notifications',
        style: AndroidNotificationStyle.BigPicture,
        styleInformation: bigPictureStyleInformation);
    final platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        4,
        'Small Image Notification title can be different',
        'Subtitle as well',
        platformChannelSpecifics,
      payload: "image"
    );
  }


  _showAlertUnavailableOnIOS() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("This is unavaliable on iOS"),
            content: Text("Please use on Android to test this feature"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }



}
