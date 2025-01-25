

 import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hair/log_ui.dart';
import 'package:hair/login.dart';
import 'package:hair/main.dart';
import 'dart:async';
import 'package:hair/signup_login.dart';
import 'package:hair/status_of_booking.dart';

class UserDashboard extends StatelessWidget {
  final String userId;

  UserDashboard({required this.userId});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

   int _currentIndex = 0;

  final List<String> _images = [
    'assets/hair1.jpeg', 
    'assets/hair2.jpeg', 
    'assets/hair3.jpeg', 
    'assets/hair4.jpeg', // Replace with your image paths
  ];
  final PageController _pageController = PageController();
  final Duration _autoSwipeInterval = Duration(seconds: 5);

  

  // Automatically swipe images after 5 seconds
  void _startAutoSwipe(BuildContext context) {
    Timer.periodic(_autoSwipeInterval, (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= _images.length) nextPage = 0;
        _pageController.animateToPage(nextPage,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }


  // @override
  Future<Map<String, String>> getUserData() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return {
          'email': snapshot['email'] ?? 'Email not found',
          'age': snapshot['age'] ?? 'Age not found',
        };
      } else {
        return {'email': 'User not found', 'age': 'N/A'};
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return {'email': 'Error retrieving email', 'age': 'Error retrieving age'};
    }
  }

 

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    _startAutoSwipe(context);
    


    return WillPopScope(
      
      onWillPop: () async {
        //Navigator.pop(context);
       // return true;
         Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => LogInUpPage()),(route) => false,);
       return false;
      },
      child:
    Scaffold(
     // resizeToAvoidBottomInset: true,
     //backgroundColor: Color(0xFFF5F5F5),
    // backgroundColor: Color(0xFFF0F0F0),
      

      body:Container(
      child: Column(
        children: [

         
          Container(
            padding: EdgeInsets.all(10),
                  height: screenheight * 0.33, // Ensure the container has a fixed height
                  width: double.infinity, // Make the container take the full width
                  decoration: const BoxDecoration(
          color: Color(0xFF681E1E), // Dark Red
          //color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(100),
          ),
                  ),
                  child: Padding(padding: EdgeInsets.only(left: 15,top:80),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.start,
            children:[
                
                 Align(
                  alignment: Alignment.topLeft,
                   child: Text(
                 "Book Your Cut", // Replace this with your desired text
                 style: TextStyle(
          color: Colors.white, // Set text color to white to stand out against the red background
          fontSize: 32, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Bold font for emphasis
                 ),
               ),
                 ),
                 SizedBox(height: screenheight*0.01,),
             Align(
                alignment: Alignment.centerLeft,
                 child: Text(
                  'Look Out Best !!!', // Replace this with your desired text
                  style: TextStyle(
                   color: Color.fromARGB(255, 220, 154, 55), // Set text color to white to stand out against the red background
          fontSize: 18, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Bold font for emphasis
          
                  ),
             ),
             ),
             SizedBox(height: screenheight*0.01,),
                Align(
                alignment: Alignment.centerLeft,
                 child: Row(children:[ Icon(Icons.sentiment_very_satisfied_outlined,size: 30,color: Color.fromARGB(255, 220, 154, 55),)
                 ,
                //  Text('-------------------',style: TextStyle(color: Color.fromARGB(255, 220, 154, 55),
                //   fontSize: 17, // Adjust the font size as neede
                //     fontWeight: FontWeight.bold, ),)
                 ])
             ),
                  ]),
                  ),
                )
      ,
      SizedBox(height: screenheight*0.03,),
      
         
           Container(
            height: screenheight * 0.26,
           // width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(60),
               boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2), // Black color with opacity for softer shadow
        offset: Offset(0, 4), // Horizontal and vertical displacement of the shadow
        blurRadius: 6, // Blur radius to make the shadow softer
        spreadRadius: 1, // How much the shadow should spread
      ),
    ],
            ),
            child: Column(
              children: [
                // Image carousel with automatic swiping
                Container(
                  height: screenheight * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      onPageChanged: (index) {
                        _currentIndex = index;
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.01),
                          child: Image.asset(
                            _images[index],
                            fit: BoxFit.fill,
                            width: screenwidth * 0.9,
                          ),
                        );
                      },
                    ),
                  ),
                ),
         
              ],
            ),
          ),
      
          SizedBox(height: screenheight*0.03,),
      
          // Account details
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD3C6),
             //color: Colors.white,
              borderRadius: BorderRadius.circular(20),
               boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2), // Black color with opacity for softer shadow
        offset: Offset(0, 4), // Horizontal and vertical displacement of the shadow
        blurRadius: 6, // Blur radius to make the shadow softer
        spreadRadius: 1, // How much the shadow should spread
      ),
    ],
            ),
            height: screenheight * 0.17,
            child: FutureBuilder<Map<String, String>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          'Account Details',
                          style: TextStyle(
                            color: Color.fromARGB(255, 220, 154, 55),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: screenheight * 0.025),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              'Your Name :  ',
                               maxLines: 1, 
      overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF681E1E),
                              ),
                            ),
                            Text(
                              '${snapshot.data!['age']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenheight * 0.01),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              'Your Mail    :  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF681E1E),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${snapshot.data!['email']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                 style: TextStyle(fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('No user data found'));
                }
              },
            ),
          ),
      
         
      
          SizedBox(height: screenheight*0.05,),
      
          Padding(padding: EdgeInsets.only(left: 15,right: 15),
            child: Container(
              height: screenheight*0.08,
              width: double.infinity,
              decoration: BoxDecoration(
                 boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2), // Black color with opacity for softer shadow
        offset: Offset(0, 4), // Horizontal and vertical displacement of the shadow
        blurRadius: 6, // Blur radius to make the shadow softer
        spreadRadius: 2, // How much the shadow should spread
      ),
    ],
                color: Color(0xFF681E1E),borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  SizedBox(height: screenheight*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(40)),
                      width: screenwidth*0.12,height: screenheight*0.03,
                        child: Icon(Icons.home,color:  Color.fromARGB(255, 220, 154, 55),)),
                  
                      GestureDetector(
                        onTap: (){
                  
                     

                    Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return CustomerPage(userId: userId);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeIn; // or any other curve
      var curveAnimation = CurvedAnimation(parent: animation, curve: curve);

      return SlideTransition(position: animation.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero)), child: child);
    },
  ),
);

                  
                        },

                        //return StatusOfBooking(userId: userId);
                        child: Icon(Icons.chair_outlined,color:  Color.fromARGB(255, 220, 154, 55),)),
                  
                      GestureDetector(
                        onTap: (){
                     
 Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return StatusOfBooking(userId: userId);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeIn; // or any other curve
      var curveAnimation = CurvedAnimation(parent: animation, curve: curve);

      return SlideTransition(position: animation.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero)), child: child);
    },
  ),
);
                        },
                        child: Icon(Icons.history_edu_outlined,color:  Color.fromARGB(255, 220, 154, 55),size: 25,))
                    ],
                  ),
      
                 
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: screenwidth*0.13,),
                      
                      GestureDetector(
                        onTap:(){

                        },
                        child: Text('Home',style: TextStyle(fontSize: 10,color: Color.fromARGB(255, 220, 154, 55),fontWeight: FontWeight.bold),)),   
                      SizedBox(width: screenwidth*0.21,),
                       GestureDetector(
                        onTap:(){

                          Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return CustomerPage(userId: userId);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeIn; // or any other curve
      var curveAnimation = CurvedAnimation(parent: animation, curve: curve);

      return SlideTransition(position: animation.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero)), child: child);
    },
  ),
);

                        },
                        child: Text('Booking',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Color.fromARGB(255, 220, 154, 55),),)),   
                        SizedBox(width: screenwidth*0.18,),
                        GestureDetector(
                          onTap:(){


                            Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return StatusOfBooking(userId: userId);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var springTween = Tween(begin: 0.0, end: 1.0);
      var springAnimation = animation.drive(springTween);

      return ScaleTransition(
        scale: springAnimation,
        child: child,
      );
    },
  ),
);


                          },
                          child: Text('History',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Color.fromARGB(255, 220, 154, 55)),)),                    
                                       
                     
                    ],),],), ),
          )],),),
    ));}}

