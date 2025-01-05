import 'package:flutter/material.dart';
import 'package:hair/log_ui.dart';

class admin_off_page extends StatefulWidget{
  @override
  State<admin_off_page> createState() => _admin_off_pageState();
}

class _admin_off_pageState extends State<admin_off_page> {
  @override
  Widget build(BuildContext context) {
     var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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
      backgroundColor: Color(0xFF681E1E),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 
                  GestureDetector(
                    onTap: () {
                               Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => LogInUpPage()),(route) => false,);

                      
                      
                    },
                    child: Text(
                        "Sign out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                ],
              ),
            ),
            // Title and message
            Spacer(),
            // Text(
            //   "Closed !",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 36,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Icon(
                      Icons.warning,
                      size: 60,
                      color:  Color.fromARGB(255, 220, 154, 55),
                    ),
            SizedBox(height: 10),
            Padding(padding: EdgeInsets.all(10),
              child: Text(
                "The salon is temporarily unavailable. Please try again later — we're here to serve you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  Color.fromARGB(255, 220, 154, 55),
                  fontSize: 16,
                ),
              ),
              
            ),
            Spacer(),
            // Semi-circle with cross icon
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                      topRight: Radius.circular(200),
                    ),
                  ),
                ),
                Positioned(
                 // top: -10,
                 bottom: 140,
                  child:  Text(
              "Closed !!!",
              style: TextStyle(
                color: Color(0xFF681E1E),
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            
                ),
              ],
            ),
          ],
        ),
      ),
    )
);
  }
}
