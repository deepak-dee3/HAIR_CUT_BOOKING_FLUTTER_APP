

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hair/forget_password.dart';
import 'package:hair/main.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:googleapis_auth/auth_io.dart';



class LogInPage extends StatefulWidget{
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   TextEditingController _emailcontroller = TextEditingController();

   TextEditingController _passcontroller = TextEditingController();

   String _email=" ";

   String _password =" ";


   void _handlesignup() async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);

      print("User registered : ${userCredential.user!.email}");
    }catch(e){

      print("error: $e");



    }
   }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Color.fromARGB(255, 134, 234, 135),

      body:Center(
        child:Form(
         key: _formKey,
           child:Column(
        
        children: [



       Padding(padding:EdgeInsets.only(top:40),child: 
       CircleAvatar(radius: 60,backgroundColor: Color.fromARGB(255, 31, 137, 29),),),


      

      SizedBox(height: 100,),

       Center(child:Container(
        width:350,
        height:400,
        color: Color.fromARGB(255, 64, 152, 67).withOpacity(0.2),
        child:Stack(
          children: [

            Column(
              children: [

                SizedBox(height: 15,),

           GestureDetector(onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => mainlogin()));
           
           },
             child:Text('sign up page',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black)),),
            SizedBox(height: 10,),

            Padding(padding:EdgeInsets.all(15),
            child:TextFormField(

              controller: _emailcontroller,



              decoration: InputDecoration(
                hintText: '    * Usermail',
                suffixIcon: Icon(Icons.mail),
               ),
               validator: (value){

                if(value == null || value.isEmpty){

                  return "please enter your mail";
                }
                return null;
              },

              onChanged: (value){

                setState((){

                  _email = value;
                });
              },
            )),
            SizedBox(height: 10,),
             Padding(padding:EdgeInsets.all(15),
             child:TextFormField(

              controller: _passcontroller,


              obscureText: true,
              decoration: InputDecoration(
                hintText: '    * Userpassword',
                suffixIcon: Icon(Icons.password),
                
                isDense: true,
              ),

              validator: (value){

                if(value == null || value.isEmpty){

                  return "please enter your pass";
                }
                return null;
              },

              onChanged: (value){

                setState((){

                  _password = value;
                });
              },



             )),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
              },
              
              child:Text('Forget Password?'),
            ),
            SizedBox(height:40),

            SizedBox(width: 150,child:ElevatedButton(onPressed: (){
              if(_formKey.currentState!.validate()){
            _handlesignup();
          }
            }, child: Text('Sign Up',style:TextStyle(color: Colors.white)),style:ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)))),

            SizedBox(height:10),

            Text('(Or)',style:TextStyle(fontSize: 15)),
          ])

          ],
        )
       )),

       SizedBox(height:30),
      

        SizedBox(width: 250,child:ElevatedButton(onPressed: (){

          Navigator.push(context, MaterialPageRoute(builder: (context) => mainlogin()));

          
        }, child: Text('Log In',style:TextStyle(color: Colors.white)),style:ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 31, 137, 29))))),


      ],)

    )));
  }
}



class mainlogin extends StatefulWidget{
  @override
  State<mainlogin> createState() => _mainloginState();
}

class _mainloginState extends State<mainlogin> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _econtroller = TextEditingController();

   TextEditingController _pcontroller = TextEditingController();

   String _eemail = " ";
   String _ppass = " ";

   void _handlelogin() async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email:_eemail,
        password:_ppass

        
       
        );
         Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
      }catch(e){

        print('error');


      }
    }
    

  
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 246, 240, 189),
      appBar: AppBar(
        title: Text('Log in page'),
      ),

      body:Center(
        child:Form(
          key:_formkey,
          child:Column(children: [
        Padding(padding:EdgeInsets.only(top:70),child:Icon(Icons.lock_open,size: 70,),),
        SizedBox(height: 50,),
        //Text('Log In ',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
        Padding(padding: EdgeInsets.all(20),
        child:TextFormField(
          controller: _econtroller,
          decoration:InputDecoration(
            
            hintText: '*      Enter your mail',
          ),
          validator: (value){
            if(value == null || value.isEmpty)
            {
              return "enter correct email";
            }
            return null;
          },
          onChanged: (value){

            setState(() {
              _eemail = value;
            });

          },
        ),),
        SizedBox(height: 20,),
        Padding(padding: EdgeInsets.all(20),
        child:TextFormField(
          controller: _pcontroller,
          decoration: InputDecoration(
            labelText: '*     Enter your password'
          ),
          validator: (value){
            if(value == null || value.isEmpty)
            {
              return "enter correct pass";
            }
            return null;
          },
          onChanged: (value){

            setState(() {
              _ppass = value;
            });

          },
          
        ),),
        SizedBox(height: 20,),
        //Padding(padding: EdgeInsets.all(20),child:TextField(),),

        SizedBox(height:50),
        SizedBox(width:250,child:ElevatedButton(onPressed: (){

          if(_formkey.currentState!.validate()){
            _handlelogin();
            

            
          }





        }, child: Text('Log In')),),
        

      ],)
    )));
  }
}