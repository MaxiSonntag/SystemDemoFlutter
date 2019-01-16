import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class AddContactPage extends StatefulWidget{

  @override
  State createState() {
    return AddContactPageState();
  }
}

class AddContactPageState extends State<AddContactPage>{

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final numberCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();


  Widget getForm(){
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: firstNameCtrl,
            decoration: InputDecoration(
                labelText: "First name"
            ),
            validator: (enteredText){
              if(enteredText.isEmpty){
                return "Please enter a first name";
              }
            },
          ),
          TextFormField(
            controller: lastNameCtrl,
            decoration: InputDecoration(
                labelText: "Last name"
            ),
            validator: (enteredText){
              if(enteredText.isEmpty){
                return "Please enter a last name";
              }
            },
          ),
          TextFormField(
            controller: numberCtrl,
            decoration: InputDecoration(
                labelText: "Number"
            ),
            keyboardType: TextInputType.number,
            validator: (enteredText){
              if(enteredText.isEmpty){
                return "Please enter a number";
              }
            },
          ),
        ],
      ),
    );
  }

  resetForm(){
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    numberCtrl.clear();
  }

  saveContact() async{
    if(formKey.currentState.validate()){
      try{
        await ContactsService.addContact(Contact(givenName: firstNameCtrl.text, familyName: lastNameCtrl.text, phones: [Item(label: "Mobile", value: numberCtrl.text)]));
        Navigator.pop(context);
      }
      catch(e){
        print("Add contact error: $e");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add contact"),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            getForm(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    child: Text("Reset"),
                    onPressed: ()=>resetForm(),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text("Save"),
                    onPressed: ()=>saveContact(),
                  )
                )
              ],
            )
          ],
        )
      ),
    );
  }
}