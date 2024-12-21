import 'package:flutter/material.dart';
import 'package:hair/log_ui.dart';

class admin_off_page extends StatefulWidget{
  @override
  State<admin_off_page> createState() => _admin_off_pageState();
}

class _admin_off_pageState extends State<admin_off_page> {
  @override
  Widget build(BuildContext context) {
    return 
     WillPopScope(
      onWillPop: () async {
        //Navigator.pop(context);
       // return true;
         Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => LogInUpPage()),(route) => false,);
       return false;
      },
      child:
    Scaffold(
      body:Center(
        child: Container(child:Text('CURRENTLY CLOSED',style: TextStyle(fontSize: 24,color: Colors.red,fontWeight: FontWeight.bold),)),
      )
    ));
  }
}