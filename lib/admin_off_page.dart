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
                      color: Colors.white,
                    ),
            SizedBox(height: 10),
            Padding(padding: EdgeInsets.all(10),
              child: Text(
                "The salon is temporarily unavailable. Please try again later — we're here to serve you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
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

// import 'package:flutter/material.dart';

// class admin_off_page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         backgroundColor: Color(0xFF3B0C0C), // Dark brownish-red color
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     spreadRadius: 5,
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Oh no!",
//                     style: TextStyle(
//                       color: Color(0xFFD32F2F), // Red
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Looks like something went wrong in verifying your input. Would you like to try again or seek help?",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 16,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       // Action for the button
//                     },
//                     icon: Icon(Icons.close, color: Colors.white),
//                     label: Text("TRY AGAIN"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFFD32F2F), // Red
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
      
//     );
//   }
// }
