import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_contact_page.dart';

class ContactsPage extends StatefulWidget{


  @override
  State createState() {
    return ContactsPageState();
  }
}

class ContactsPageState extends State<ContactsPage>{

  var isLoading = true;
  var hasPermissions;
  List<Contact> allContacts;


  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Widget getContent(){
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if(!hasPermissions){
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You need to grant permissions for contacts usage.", softWrap: true, textAlign: TextAlign.center,),
            FlatButton.icon(onPressed: loadContacts, icon: Icon(Icons.refresh), label: Text("Retry"))
          ],
        ),
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: ()=>add(),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: allContacts.length,
        itemBuilder: (context, index){
          final title = allContacts[index].displayName;
          final subtitle = "${allContacts[index].phones.toList()[0].label}: ${allContacts[index].phones.toList()[0].value}";
          return ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            onTap: ()=>contactTapped(index),
          );
        },
      ),
    );
  }

  loadContacts() async{
    setState(() {
      isLoading = true;
    });

    final read = await checkPermissions(Permission.ReadContacts);
    final write = await checkPermissions(Permission.WriteContacts);
    final permissions = read && write;
    if(permissions){
      final contacts = await ContactsService.getContacts();
      final temp = contacts.toList();
      temp.removeWhere((c)=>c.phones.toList().isEmpty);
      this.allContacts = temp;
      this.allContacts.sort((c1, c2){
        return c1.displayName.toLowerCase().compareTo(c2.displayName.toLowerCase());
      });
      setState(() {
        hasPermissions = true;
        isLoading = false;
      });
    }
    else{
      setState(() {
        hasPermissions = false;
        isLoading = false;
        
      });
    }

  }

  Future<bool> checkPermissions(Permission permission) async{
    final res = await SimplePermissions.checkPermission(permission);
    if(res){
      return true;
    }
    final res2 = await SimplePermissions.requestPermission(permission);
    if(res2 == PermissionStatus.authorized){
      return true;
    }
    return false;

  }

  delete(Contact contact) async{
    await ContactsService.deleteContact(contact);
    Navigator.pop(context);
    setState(() {
      isLoading = true;
    });
  }

  add() async{
    await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddContactPage()));
    setState(() {
      isLoading = true;
    });
  }

  contactTapped(int index){
    final c = allContacts[index];
    final messageCtrl = TextEditingController();
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Send SMS", style: Theme.of(context).textTheme.title,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Enter a message you want to send to ${c.displayName}", style: Theme.of(context).textTheme.body1),
                TextField(controller: messageCtrl,)
              ],
            ),
            actions: <Widget>[

              FlatButton(
                child: Text("Delete"),
                onPressed: ()=>delete(c),
              ),
              FlatButton(
                child: Text("Call"),
                onPressed: ()=>call(c.phones.first.value),
              ),

              FlatButton(
                child: Text("Send"),
                onPressed: ()=>sendSms(c.phones.first.value, messageCtrl.text),
              ),

            ],
          );
      }
    );

  }

  sendSms(String number, String message) async{
    final permissions = await checkPermissions(Permission.SendSMS);
    if(permissions){
      final result = await FlutterSms.sendSMS(message: message, recipients: [number]);
      print("SMS SENDING RESULT: $result");
    }

  }

  call(String number) async{
    final url = "tel:$number";
    if(await canLaunch(url)){
      launch("tel:$number");
    }

  }

  @override
  Widget build(BuildContext context) {
    return getContent();
  }
}