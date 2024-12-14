import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hair/main.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Auth Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AuthService(),
//     );
//   }
// }

class AuthService extends StatelessWidget {
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
        'age': age,  // Store the user's age
        'initial_random_number':0,
        'date':"Not Yet Started",
      });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In / Sign Up')),
      body: SignInUpForm(),
    );
  }
}

class SignInUpForm extends StatefulWidget {
  @override
  _SignInUpFormState createState() => _SignInUpFormState();
}

class _SignInUpFormState extends State<SignInUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();  // Controller for age input
  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          if (isSignUp) ...[
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (isSignUp) {
                User? user = await AuthService().signUpWithEmailPassword(
                  _emailController.text,
                  _passwordController.text,
                  _ageController.text,  // Pass the age
                );
                if (user != null) {
                  // Navigate to User Dashboard after successful sign-up
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserDashboard(userId: user.uid)),
                  );
                }
              } else {
                User? user = await AuthService().signInWithEmailPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  // Navigate to User Dashboard after successful login////////////
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserDashboard(userId: user.uid)),
                  );
                }
              }
            },
            child: Text(isSignUp ? 'Sign Up' : 'Log In'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isSignUp = !isSignUp;
              });
            },
            child: Text(isSignUp
                ? 'Already have an account? Log In'
                : 'Don\'t have an account? Sign Up'),
          ),
        ],
      ),
    );
  }
}

class UserDashboard extends StatelessWidget {
  final String userId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserDashboard({required this.userId});

  // Get the user's email and age from Firestore
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
    return Scaffold(
      appBar: AppBar(title: Text('User Dashboard')),
      body: FutureBuilder<Map<String, String>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Center(
                  child: Text(
                    'Welcome, ${snapshot.data!['email']}\nAge: ${snapshot.data!['age']}',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerPage(userId: userId),
                      ),
                    );
                  },
                  child: Text('Go to admin'),
                ),
              ],
            );
          } else {
            return Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}


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
//     return Scaffold(
//       appBar: AppBar(title: Text('User Dashboard')),
//       body: FutureBuilder<Map<String, String>>(
//         future: getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return Column(children:[Center(
//               child: Text(
//                 'Welcome, ${snapshot.data!['email']}\nAge: ${snapshot.data!['age']}',
//                 textAlign: TextAlign.center,
//               ),
//             ),

//             ElevatedButton(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerPage(userId: userId)));
//             }, child: Text('Go to admin'))
//             ]);
//           } else {
//             return Center(child: Text('No user data found'));
//           }
//         },
//       ),
//     );
//   }
// }