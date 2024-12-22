// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hair/main.dart';

// class AuthService extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Sign up with email, password, and age
//   Future<User?> signUpWithEmailPassword(String email, String password, String age) async {
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Create a document for the user in Firestore under the 'users' collection
//       await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
//         'email': email,
//         'age': age,  // Store the user's age
//         'initial_random_number':0,
//         'date':"Not Yet Started",
//       });
//       // await FirebaseFirestore.instance.collection('users_history').doc(userCredential.user!.uid).set({
        
//       //   '0':"0",
        
//       // });
//       await FirebaseFirestore.instance.collection('users_history').doc(userCredential.user!.uid);

//       return userCredential.user;
//     } catch (e) {
//       print('Error signing up: $e');
//       return null;
//     }
//   }

//   // Sign in with email and password
//   Future<User?> signInWithEmailPassword(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
        
        
//       );
//       return userCredential.user;
      
      
//     } catch (e) {
//       print('Error signing in: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign In / Sign Up')),
//       body: SignInUpForm(),
//     );
//   }
// }

// class SignInUpForm extends StatefulWidget {
//   @override
//   _SignInUpFormState createState() => _SignInUpFormState();
// }

// class _SignInUpFormState extends State<SignInUpForm> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();  // Controller for age input
//   bool isSignUp = true;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//           TextField(
//             controller: _passwordController,
//             decoration: InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           if (isSignUp) ...[
//             TextField(
//               controller: _ageController,
//               decoration: InputDecoration(labelText: 'Age'),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               if (isSignUp) {
//                 User? user = await AuthService().signUpWithEmailPassword(
//                   _emailController.text,
//                   _passwordController.text,
//                   _ageController.text,  // Pass the age
//                 );
//                 if (user != null) {
//                   // Navigate to User Dashboard after successful sign-up
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => UserDashboard(userId: user.uid)),
//                   );
//                 }
//               } else {
//                 User? user = await AuthService().signInWithEmailPassword(
//                   _emailController.text,
//                   _passwordController.text,
//                 );
//                 if (user != null) {
//                   // Navigate to User Dashboard after successful login////////////
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => UserDashboard(userId: user.uid)),
//                   );
//                 }
//               }
//             },
//             child: Text(isSignUp ? 'Sign Up' : 'Log In'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 isSignUp = !isSignUp;
//               });
//             },
//             child: Text(isSignUp
//                 ? 'Already have an account? Log In'
//                 : 'Don\'t have an account? Sign Up'),
//           ),
//         ],
//       ),
//     );
//   }
// }

//////the above code is important and this is old sign and sigup page in one page
///
//  import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hair/main.dart';
// import 'dart:async';

// import 'package:intl/intl.dart';

// class UserDashboard extends StatelessWidget {
//   final String userId;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   UserDashboard({required this.userId});

//   // Get the user's email and age from Firestore
//   Future<Map<String, String>> getUserData() async {
//     try {
//       DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
//       if (snapshot.exists) {
//         return {
//           'email': snapshot['email'] ?? 'Email not found',
//           'age': snapshot['age'] ?? 'Age not found',
//         };
//       } else {
//         return {'email': 'User not found', 'age': 'N/A'};
//       }
//     } catch (e) {
//       print('Error retrieving user data: $e');
//       return {'email': 'Error retrieving email', 'age': 'Error retrieving age'};
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//      var screenheight = MediaQuery.of(context).size.height;
//     var screenwidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       //appBar: AppBar(title: Text('User Dashboard')),
//       body: SingleChildScrollView(


//         child: Stack(
//           clipBehavior: Clip.none,
//           children:[ 
//              Container(
//               height: screenheight*0.4,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF681E1E), // Dark Red
//                 borderRadius: BorderRadius.only(
//                    bottomLeft: Radius.circular(80),
//                   bottomRight: Radius.circular(80),
//                 ),
//               ),
//             ),

//             Positioned(
//               top: 280,
//               left: 30,
//               right: 30,
//               child: Container(
//                 height: screenheight*0.25,

//                 decoration: BoxDecoration(
//                   // boxShadow: [
//                   //   BoxShadow(color: Colors.black,blurRadius: 1)
//                   // ],
//                    color: const Color(0xFFFFD3C6),//Color.fromARGB(255, 220, 154, 55),
//                    borderRadius: BorderRadius.circular(20)

//                 ),
               
//               child: Text('hello')
//                         ),
//             ),
//             Positioned(
//                top: 515, // Adjust this value based on your container height
//         left: 30,
//         right: 30,
//               child: Container(
                
                
//               decoration: BoxDecoration(color: const Color(0xFFFFD3C6),borderRadius: BorderRadius.circular(20)),
//               height: screenheight*0.13,
//               width: screenwidth*0.05,
//               child: Center(
//                 child:
//                 FutureBuilder<Map<String, String>>(
//                 future: getUserData(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData) {
//                     return Column(
//                       children: [
//                         Container(child: Text('Account Details',style: TextStyle(color: Color.fromARGB(255, 220, 154, 55),fontWeight: FontWeight.bold,fontSize: 16),),),
//                         SizedBox(height: screenheight*0.012,),
//                         Padding(padding: EdgeInsets.only(left:15),
//                           child: Container(
//                             child:Row(
//                               children: [
//                                 Text('Your Name :  ',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF681E1E)),),
//                                 Text('${snapshot.data!['age']}',maxLines: 1,overflow:TextOverflow.ellipsis,)
//                               ],
//                             )
//                           ),
//                         ),
//                         SizedBox(height: screenheight*0.01,),
//                         Padding(padding: EdgeInsets.only(left:15),
//                           child: Container(
//                             child:Row(
//                               children: [
//                                 Text('Your Mail    :  ',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF681E1E)),),
//                                 Text('${snapshot.data!['email']}',maxLines: 1,overflow:TextOverflow.ellipsis,)
//                               ],
//                             )
//                           ),
//                         )
                       
//                       ],
//                     );
//                   } else {
//                     return Center(child: Text('No user data found'));
//                   }
//                 },
//               ),
//                 )
//             )),
        
//              Positioned(
//               top: 650, // Adjust this value based on your container height
//         left: 30,
//         right: 30,
//                child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
               
//                  children:[ 
//                   GestureDetector(
//                      onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CustomerPage(userId: userId),
//                                     ),
//                                   );
//                                 },
                               
//                     child: Container(
//                       height: screenheight*0.18,
//                       width: screenwidth*0.4,
//                       decoration: BoxDecoration(color: Color(0xFF681E1E),
//                       borderRadius: BorderRadius.circular(20)
                      
//                       ),
//                        child: Center(child: Text('Start/nBooking',style: TextStyle(color: Color.fromARGB(255, 220, 154, 55),fontWeight: FontWeight.bold,fontSize: 16),)),
                      
//                     ),
//                   ),
                  
//                    InkWell(
                    
//                     onTap: (){
//                       print('hello');
//                        Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CustomerPage(userId: userId),
//                                     ),
//                                   );
//                     },
//                      child: Container(
//                        height: screenheight*0.18,
//                        width: screenwidth*0.4,
//                        decoration: BoxDecoration(color: Color(0xFF681E1E),
//                        borderRadius: BorderRadius.circular(20)
                       
//                        ),
//                         child: Center(child: Text('Watch / Status',style: TextStyle(color: Color.fromARGB(255, 220, 154, 55),fontWeight: FontWeight.bold,fontSize: 16),)),
                       
//                      ),
//                    ),
//           ]),
//              ),

//              Positioned(top:65,left: 30,
//               child: Container(
//               child: Text("Let's Start",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
//              )),
//              Positioned(top:115,left: 30,
//               child: Container(
//               child: Text("The Beggining !!!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 220, 154, 55),),),
//              ))
//         ]),
//       ),
//     );
//   }
// }




// class CurrentTimeWidget extends StatefulWidget {
//   @override
//   _CurrentTimeWidgetState createState() => _CurrentTimeWidgetState();
// }

// class _CurrentTimeWidgetState extends State<CurrentTimeWidget> {
//   String _currentTime = '';

//   @override
//   void initState() {
//     super.initState();
//     _updateTime();
//   }

//    void _updateTime() {
//     Timer.periodic(Duration(minutes: 1), (Timer timer) {
//       setState(() {
//         _currentTime = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()); // Update time and date
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       _currentTime.isEmpty ? "Loading..." : _currentTime,
//       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     );
//   }
// }

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
    'assets/hair1.jpeg', // Replace with your image paths
    'assets/hair2.jpeg', // Replace with your image paths
    'assets/hair3.jpeg', // Replace with your image paths
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
      backgroundColor: Colors.white,
      

      body:Container(
      child: Column(
        children: [

         
          Container(
        height: screenheight * 0.33, // Ensure the container has a fixed height
        width: double.infinity, // Make the container take the full width
        decoration: const BoxDecoration(
          color: Color(0xFF681E1E), // Dark Red
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
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
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
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
                // Dots indicator
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List.generate(
                //     _images.length,
                //     (index) => AnimatedContainer(
                //       duration: Duration(milliseconds: 300),
                //       margin: EdgeInsets.symmetric(horizontal: 5),
                //       height: 8,
                //       width: _currentIndex == index ? 20 : 8,
                //       decoration: BoxDecoration(
                //         color: _currentIndex == index
                //             ? Color(0xFF681E1E)
                //             : Colors.grey,
                //         borderRadius: BorderRadius.circular(4),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
      
          SizedBox(height: screenheight*0.03,),
      
          // Account details
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD3C6),
              borderRadius: BorderRadius.circular(20),
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
                            Text(
                              '${snapshot.data!['email']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                               style: TextStyle(fontWeight: FontWeight.bold,),
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
      
          // Navigation buttons
          //SizedBox(height: screenheight * 0.005), // Space between sections
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => CustomerPage(userId: userId),
          //           ),
          //         );
          //       },
          //       child: Container(
          //         height: screenheight * 0.18,
          //         width: screenwidth * 0.4,
          //         decoration: BoxDecoration(
          //           color: Color(0xFF681E1E),
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Center(
          //           child: Text(
          //             'Start  Booking',
          //             style: TextStyle(
          //               color: Color.fromARGB(255, 220, 154, 55),
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         print('hello');
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => StatusOfBooking(userId: userId),
          //           ),
          //         );
          //       },
          //       child: Container(
          //         height: screenheight * 0.18,
          //         width: screenwidth * 0.4,
          //         decoration: BoxDecoration(
          //           color: Color(0xFF681E1E),
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Center(
          //           child: Text(
          //             'Watch  Status',
          //             style: TextStyle(
          //               color: Color.fromARGB(255, 220, 154, 55),
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
      
          SizedBox(height: screenheight*0.05,),
      
          Padding(padding: EdgeInsets.only(left: 15,right: 15),
            child: Container(
              height: screenheight*0.08,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xFF681E1E),borderRadius: BorderRadius.circular(40)),
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
                  
                      //      Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CustomerPage(userId: userId),
                      //   ),
                      // );

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
                        child: Icon(Icons.chair_outlined,color:  Color.fromARGB(255, 220, 154, 55),)),
                  
                      GestureDetector(
                        onTap: (){
                      //      Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => StatusOfBooking(userId: userId),
                      //   ),
                      // );
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
                        child: Icon(Icons.history_edu_outlined,color:  Color.fromARGB(255, 220, 154, 55),size: 25,))
                    ],
                  ),
      
                 
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: screenwidth*0.13,),
                      
                      Text('Home',style: TextStyle(fontSize: 10,color: Color.fromARGB(255, 220, 154, 55),fontWeight: FontWeight.bold),),   
                      SizedBox(width: screenwidth*0.21,),
                       Text('Booking',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Color.fromARGB(255, 220, 154, 55),),),   
                        SizedBox(width: screenwidth*0.18,),
                        Text('History',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Color.fromARGB(255, 220, 154, 55)),),                    
                                       
                     
                    ],
                                        ),
                ],
              ),
            ),
          )
        ],
      ),
            ),

    ));
  }
}

