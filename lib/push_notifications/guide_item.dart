import 'package:flutter/material.dart';

class GuideItem extends StatelessWidget{
  
  final int step;
  final String title;
  final String description;
  final String imageName;
  
  final TextStyle titleStyle = TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold);
  final TextStyle descriptionStyle = TextStyle(color: Colors.black54, fontSize: 15.0);

  GuideItem({@required this.step, @required this.title, this.description, this.imageName});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("$step. $title", style: titleStyle, textAlign: TextAlign.start),
        Container(
          margin: EdgeInsets.only(top: 4.0, bottom: 6.0),
          child: Text("$description", style: descriptionStyle, textAlign: TextAlign.start,),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.black54, width: 1.0, style: BorderStyle.solid)
          ),
          child: Image.asset("lib/push_notifications/images/$imageName.png", fit: BoxFit.contain,),
        ),
      ],
    );
  }
}