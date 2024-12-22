

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hair/log_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String forgetEmail = ' ';
  TextEditingController forgetMailController = TextEditingController();
  final forgetFormKey = GlobalKey<FormState>();

  Future<void> sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgetEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Check your mailbox for the password reset link.',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>LogInUpPage()), // Your home widget
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'No user found with this email address.',
              style: TextStyle(fontSize: 15),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Container(
                  height: screenHeight*0.07,
                 decoration: BoxDecoration(
                   color: const Color(0xFFFFD3C6),borderRadius: BorderRadius.circular(20)
                 ),
                  child: Center(
                    child: Text(
                      'PASSWORD RECOVERY',
                      style: TextStyle(
                        color: Color(0xFF681E1E),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Lottie.asset(
                  'assets/Animation - 1721316481945 (1).json',
                  height: 200,
                ),
                SizedBox(height: screenHeight * 0.08),
                Container(
                  height: screenHeight*0.3,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD3C6),
                    borderRadius: BorderRadius.circular(15),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     blurRadius: 10,
                    //     spreadRadius: 5,
                    //   ),
                    // ],
                  ),
                  child: Form(
                    key: forgetFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Your Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF681E1E),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextFormField(
                          controller: forgetMailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+$')
                                .hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Center(
                          child: SizedBox(
                            width: screenWidth * 0.6,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (forgetFormKey.currentState!.validate()) {
                                  setState(() {
                                    forgetEmail =
                                        forgetMailController.text.trim();
                                  });
                                  sendPasswordResetEmail();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF681E1E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Send Reset Link',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
