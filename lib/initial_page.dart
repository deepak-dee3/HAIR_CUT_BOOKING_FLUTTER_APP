
import 'package:flutter/material.dart';
import 'package:hair/log_ui.dart';
import 'dart:ui';

import 'package:hair/login.dart'; // For the ImageFilter class

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with blur effect
          Container(
            height: screenHeight,
            width: screenWidth,
            child: Image.asset(
              'assets/qqqq.jpeg', // Replace with your image path
             // 'assets/par2.jpeg',
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          // Blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), // Apply blur
              child: Container(
                color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
              ),
            ),
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight*0.5,),
                Text(
                  "Discover perfect salon\nfor unique needs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight*0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LogInUpPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                    backgroundColor: Color(0xFF681E1E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(color: Color.fromARGB(255, 220, 154, 55),
                      fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ],),),],),);}}

