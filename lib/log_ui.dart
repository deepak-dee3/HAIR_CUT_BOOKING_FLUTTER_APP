import 'package:flutter/material.dart';
import 'package:hair/MAIN%20PAGE/admin_dup.dart';
import 'package:hair/admin_off_page.dart';
import 'package:hair/forget_password.dart';
import 'package:hair/initial_page.dart';
import 'package:hair/main.dart';
import 'package:hair/signup_login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email, password, and age
  Future<User?> signUpWithEmailPassword(String email, String password, String age) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a document for the user in Firestore under the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'age': age,
        'initial_random_number': 0,
        'date': "Not Yet Started",
      });

      // Initialize user history in Firestore
      await FirebaseFirestore.instance.collection('users_history').doc(userCredential.user!.uid);

      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }
}


class SignInUpPage extends StatefulWidget {
  const SignInUpPage({Key? key}) : super(key: key);

  @override
  State<SignInUpPage> createState() => _SignInUpPageState();
}

class _SignInUpPageState extends State<SignInUpPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  
  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return  WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child:
    Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none, // Allows widgets to overflow the Stack
          children: [
            // Background Container
            Container(
             
              height: screenheight*0.4,
              decoration: const BoxDecoration(
                color: Color(0xFF681E1E), // Dark Red
                borderRadius: BorderRadius.only(
                   //bottomLeft: Radius.circular(300),
                  bottomRight: Radius.circular(300),
                ),
              ),
            ),

            // Positioned Sign In Container
            Positioned(
              top: 220, // Adjust the position to overlap the background
              left: 30,
              right: 30,
              child: Container(
                height: screenheight*0.7,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenheight*0.05,),
                    // Sign In Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 40,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD3C6), // Light Red/Pink
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Color(0xFF681E1E), // Dark Red
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                     SizedBox(height:  screenheight*0.053),

                    // Email Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.03,),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.lock_outline,shadows: [
                          Shadow(
                            color: Color(0xFF681E1E),
                            //blurRadius: 3,
                            
                          )
                        ],),
                       
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.03,),

                    // Password Field
                    TextField(
                      controller: _nameController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.password,shadows: [
                          Shadow(
                            color: Color(0xFF681E1E),
                            //blurRadius: 3,
                            
                          )
                        ],),
                       
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    
                     SizedBox(height: screenheight*0.053,),

                    // Log In Button
                    GestureDetector(
                      onTap: () async {
                User? user = await _authService.signUpWithEmailPassword(
                  _emailController.text,
                  _passwordController.text,
                  _nameController.text,
                );
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserDashboard(userId: user.uid)),
                  );
                }
              },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF681E1E), // Dark Red
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'ENTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                     SizedBox(height: screenheight*0.05,),
                  ],
                ),
              ),
              
            ),
           // Text('dat',style: TextStyle(color: Colors.red),)

            // //Additional Spacing for Scrollable Effect
            // Positioned(
            //   //left: 180,
            //   top: 750, // Add enough space after the Sign In container
            //   child: Text('Already hav an account ?')
            // ),

            GestureDetector(
              onTap: (){
                 Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>LogInUpPage()), // Your home widget
        (route) => false,
      );
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LogInUpPage()));
//                 Navigator.push(
//       context,
//       PageTransition(
//         type: PageTransitionType.rightToLeft,
//         curve: Curves.linear,
//         child: LogInUpPage(),
//         inheritTheme: true,
//         ctx: context),
// );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 750),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Already have an account ? ',
                    style: TextStyle(
                       color: Color(0xFF681E1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
           


          ],
        ),
        
        
      ),
    ));
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
///





// class LogInUpPage extends StatefulWidget {
//   const LogInUpPage({Key? key}) : super(key: key);

//   @override
//   State<LogInUpPage> createState() => _LogInUpPageState();
// }

// class _LogInUpPageState extends State<LogInUpPage> {

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final AuthService _authService = AuthService();


  



//   @override
//   Widget build(BuildContext context) {
//     var screenheight = MediaQuery.of(context).size.height;
//     var screenwidth = MediaQuery.of(context).size.width;

//     return  WillPopScope(
//     onWillPop: () async {
//       return await showDialog(
        
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: Color(0xFF681E1E),
          
//           title: Text('Confirm Exit !!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//           content: Text('Are you sure you want to exit?',style: TextStyle(color: Colors.white),),
//           actions: <Widget>[
//             TextButton(
//               child: Text('No',style: TextStyle(color: const Color(0xFFFFD3C6),fontWeight: FontWeight.bold),),
//               onPressed: () => Navigator.of(context).pop(false),
//             ),
//             TextButton(
//               child: Text('Yes',style: TextStyle(color: const Color(0xFFFFD3C6),fontWeight: FontWeight.bold)),
//               onPressed: () => Navigator.of(context).pop(true),
//             ),
//           ],
//         ),
//       );
//     },
//     child:
//     Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Stack(
//           clipBehavior: Clip.none, // Allows widgets to overflow the Stack
//           children: [
//             // Background Container
//             Container(
//               height: screenheight*0.4,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF681E1E), // Dark Red
//                 borderRadius: BorderRadius.only(
//                    bottomLeft: Radius.circular(300),
//                  // bottomRight: Radius.circular(300),
//                 ),
//               ),
//             ),

//             // Positioned Sign In Container
//             Positioned(
//               top: 220, // Adjust the position to overlap the background
//               left: 30,
//               right: 30,
//               child: Container(
//                 height: screenheight*0.55,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: screenheight*0.05,),
//                     // Sign In Header
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 40,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFFD3C6), // Light Red/Pink
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Text(
//                         'LOG IN',
//                         style: TextStyle(
//                           color: Color(0xFF681E1E), // Dark Red
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                      SizedBox(height: screenheight*0.053,),

//                     // Email Field
//                     TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         hintText: 'Email',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         suffixIcon: const Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                      SizedBox(height: screenheight*0.03,),

//                     // Password Field
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         hintText: 'Password',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         suffixIcon: const Icon(Icons.lock_outline),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                      SizedBox(height: screenheight*0.053,),


//                     // Log In Button
//                     GestureDetector(
//                       onTap: () async {

//                         if (_emailController.text.trim() == 'admin@gmail.com' &&
//                             _passwordController.text.trim() == 'Admin@11') {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AdminPage(),
//                             ),
//                           );
//                         }
//                         else{
//                 User? user = await _authService.signInWithEmailPassword(
//                   _emailController.text.trim(),
//                   _passwordController.text.trim(),
//                 );
//                 if (user != null) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => UserDashboard(userId: user.uid)),
//                   );
//                 } else {
//                             // Show an error message if authentication fails
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Invalid email or password'),
//                               ),
//                             );
//                           }
//               }},
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF681E1E), // Dark Red
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'ENTER',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                      SizedBox(height: screenheight*0.05,),
//                   ],
//                 ),
//               ),
              
//             ),
//              GestureDetector(
              
//                onTap: (){
//                // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInUpPage()));
//                Navigator.push(
//       context,
//       PageTransition(
//         type: PageTransitionType.leftToRight,
//         curve: Curves.linear,
//         child: ForgetPassword(),
//         inheritTheme: true,
//         ctx: context),
// );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 630),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Forgot Password  ',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             GestureDetector(
              
//                onTap: (){
//                // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInUpPage()));
//                Navigator.push(
//       context,
//       PageTransition(
//         type: PageTransitionType.leftToRight,
//         curve: Curves.linear,
//         child: SignInUpPage(),
//         inheritTheme: true,
//         ctx: context),
// );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 750),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Create a new account ? ',
//                     style: TextStyle(
//                       color: Color(0xFF681E1E),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
           


//           ],
//         ),
        
        
//       ),
//     ));
//   }
// }
class LogInUpPage extends StatefulWidget {
  const LogInUpPage({Key? key}) : super(key: key);

  @override
  State<LogInUpPage> createState() => _LogInUpPageState();
}

class _LogInUpPageState extends State<LogInUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch salon availability status from Firestore
  Future<bool> _getSalonAvailability() async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('Settings').doc('salonAvailability').get();
      if (snapshot.exists) {
        return snapshot['isOn'] ?? false; // Get the 'isOn' value
      } else {
        return false; // Default to false if no data found
      }
    } catch (e) {
      print("Error fetching salon availability: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFF681E1E),
            title: Text('Confirm Exit !!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: Text('Are you sure you want to exit?', style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              TextButton(
                child: Text('No', style: TextStyle(color: const Color(0xFFFFD3C6), fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Yes', style: TextStyle(color: const Color(0xFFFFD3C6), fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: screenheight * 0.4,
                decoration: const BoxDecoration(
                  color: Color(0xFF681E1E),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(300)),
                ),
              ),
              Positioned(
                top: 220,
                left: 30,
                right: 30,
                child: Container(
                  height: screenheight * 0.55,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenheight * 0.05),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD3C6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'LOG IN',
                          style: TextStyle(
                            color: Color(0xFF681E1E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenheight * 0.053),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenheight * 0.03),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenheight * 0.053),
                      GestureDetector(
                        onTap: () async {
                          // Check if admin login credentials are correct
                          if (_emailController.text.trim() == 'admin@gmail.com' &&
                              _passwordController.text.trim() == 'Admin@11') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminPage(),
                              ),
                            );
                          } else {
                            // User login with email and password
                            User? user = await _authService.signInWithEmailPassword(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            if (user != null) {
                              // Check if the salon is available
                              bool isSalonOpen = await _getSalonAvailability();
                              if (isSalonOpen) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDashboard(userId: user.uid),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>admin_off_page(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid email or password'),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF681E1E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'ENTER',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenheight * 0.05),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRight,
                      curve: Curves.linear,
                      child: ForgetPassword(),
                      inheritTheme: true,
                      ctx: context,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 630),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRight,
                      curve: Curves.linear,
                      child: SignInUpPage(),
                      inheritTheme: true,
                      ctx: context,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 750),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Create a new account ? ',
                      style: TextStyle(
                        color: Color(0xFF681E1E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
