import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hair/approved_admin_page.dart';
import 'package:hair/forget_password.dart';
import 'package:hair/initial_page.dart';
import 'package:hair/log_ui.dart';
import 'dart:math';
import 'package:hair/login.dart';
import 'package:hair/payment.dart';
import 'package:hair/random_number_page.dart';
import 'package:hair/signin_login.dart';
import 'package:hair/signup_login.dart';
import 'package:hair/status_of_booking.dart';
import 'package:hair/testing/booking_pags.dart';
import 'package:page_transition/page_transition.dart'; 
import 'dart:ui'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      home:AnimatedSplashScreen(nextScreen: InitialPage(),
      splash:Center(child:Container(height: screenheight*0.5,width: double.infinity,
        child:Column(
        children: [
          Icon(Icons.cut , size: 35,color: const Color.fromARGB(255, 220, 154, 55),),
          Spacer(),
         // SizedBox(height: screenheight*0.02,),
          Text('Booking System',style: TextStyle(color: Color(0xFF681E1E),fontWeight: FontWeight.bold,fontSize: 22),)
        ],
      ),)),//Text('Welcome To Hair Saloon',style:TextStyle(fontWeight: FontWeight.bold ,fontSize: 15)),
      duration: 3000,
     
      backgroundColor: Colors.white,
      pageTransitionType:PageTransitionType.leftToRight,
     
     
    ));
    }

}


class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

bool isOn = false;
int selectedSection = 0;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  _fetchStatus() async {
    // Fetch the current status from Firestore (or your database)
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('salonAvailability')
        .get();
    setState(() {
      isOn = snapshot.exists ? snapshot['isOn'] ?? false : false;
    });
  }

  _toggleSwitch(bool value) async {
    setState(() {
      isOn = value;
    });

    // Update the status in Firestore (or your database)
    await FirebaseFirestore.instance
        .collection('Settings')
        .doc('salonAvailability')
        .set({'isOn': isOn});
  }



  @override
  Widget build(BuildContext context) {
     var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
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
      
      backgroundColor: Colors.white,
     
      body: ListView(
        children: [
          SizedBox(height: screenheight*0.02,),

        
          
          Padding(padding: EdgeInsets.only(left: 16,right: 16),
            child: Container(
              height: screenheight*0.13,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF681E1E),
              ),
              child: Align(alignment: Alignment.center,
              
                child: Container(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Hello , Buddy',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                      

          

                    ],
                  )
                ),
              ),
            ),
          ),
          SizedBox(height: screenheight*0.04,),
            Padding(
            padding: const EdgeInsets.only(left: 25,right: 25),
            child: Container(
              height: screenheight*0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Shadow color
        spreadRadius: 5, // Spread radius
        blurRadius: 7, // Blur radius
        offset: Offset(0, 3), // Shadow offset (x, y)
      ),
    ],
              ),
            
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: screenheight*0.07,
                    width:  screenheight*0.07,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.2)
              ),
                    child:  Transform.scale(
                      scale: 0.8,
                      child: Switch(
                          
                          inactiveThumbColor: const Color.fromARGB(255, 220, 154, 55),
                          
                          inactiveTrackColor: Colors.white,
                          activeColor: const Color.fromARGB(255, 220, 154, 55),
                                  value: isOn,
                                  onChanged: _toggleSwitch,
                                ),
                    ),
                  ),
                   Container(
                    height: screenheight*0.07,
                    width:  screenheight*0.07,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.2)
              ),
                    child: Icon(Icons.notification_add),
                  ),
                   GestureDetector(
                    onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ApprovedSeatsPage(currentDate: currentDate)));
                        },
                     child: Container(
                      height: screenheight*0.07,
                      width:  screenheight*0.07,
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                                     color: Colors.grey.withOpacity(0.2)
                                   ),
                      child: Icon(Icons.approval,color: Color.fromARGB(255, 220, 154, 55),size: 28,),
                                       ),
                   ),
                   Container(
                    height: screenheight*0.07,
                    width:  screenheight*0.07,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.2)
              ),
                    child:  Center(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection(currentDate).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Stack(
                              children: [
                                Icon(Icons.notifications, size: 28,color:  Color.fromARGB(255, 220, 154, 55)),
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,),),),),],);}
                      
                          num yellowSeatsCount = 0;
                      
                      for (var doc in snapshot.data!.docs) {
                        var seatData = doc['seats'] ?? [];
                        yellowSeatsCount += seatData
                            .where((seat) => seat['status'] == 'Requested')
                            .length;
                      }
                      
                      
                          return Stack(
                            children: [
                              Icon(Icons.notifications, size: 28,color:  Color.fromARGB(255, 220, 154, 55)),
                              if (yellowSeatsCount > 0)
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      '$yellowSeatsCount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            
            ),
          ),
          SizedBox(height: screenheight*0.04,),

          Padding(padding: EdgeInsets.only(left: 16,right: 16),
            child: Container(
              decoration: BoxDecoration(
                 color: const Color.fromARGB(255, 220, 154, 55),
                 borderRadius: BorderRadius.circular(20)
              ),
              height: screenheight*0.2,
             
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                
                    Padding(padding: EdgeInsets.only(left: 16,right: 16),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                         Row(children:[ 
                         CircleAvatar(radius: 10,backgroundColor: Colors.grey,),
                         SizedBox(width: screenwidth*0.03,),
                         Text('Available',style: TextStyle(fontWeight: FontWeight.bold),)
                         ]),
                      Row(children:[ 
                        CircleAvatar(radius: 10,backgroundColor: Color.fromARGB(255, 229, 225, 10),),
                        SizedBox(width: screenwidth*0.03,),
                        Text('Requested',style: TextStyle(fontWeight: FontWeight.bold),)
                        ]),]),
                    ),
                
                    SizedBox(height: screenheight*0.03,),
                
                       Padding(padding: EdgeInsets.only(left: 16,right: 16),
                         child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                         Row(children:[ 
                         CircleAvatar(radius: 10,backgroundColor: Colors.blue,),
                         SizedBox(width: screenwidth*0.03,),
                         Text('Approved',style: TextStyle(fontWeight: FontWeight.bold),)
                         ]),
                                         Row(children:[ 
                                           CircleAvatar(radius: 10,backgroundColor: Colors.green,),
                                           SizedBox(width: screenwidth*0.03,),
                                           Text('Completed',style: TextStyle(fontWeight: FontWeight.bold),)
                                           ]),]),
                       ),
                       SizedBox(height: screenheight*0.03,),
                          
                          
                          Padding(padding: EdgeInsets.only(left: 45,right: 16),child: Align(alignment: Alignment.centerLeft,
                            child: Row(
                              children:[ 
                              
                              CircleAvatar(radius: 10,backgroundColor: Colors.red,),
                              SizedBox(width: screenwidth*0.03,),
                              Text('Rejected',style: TextStyle(fontWeight: FontWeight.bold),)
                              ])),)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: screenheight*0.04,),

          _buildTimeslotSection("Morning","(06:00 am - 09:59 am)"),
          _buildTimeslotSection("Noon","(10:00 am - 03:59 pm)"),
          _buildTimeslotSection("Evening","(04:00 pm - 06:59 pm)"),
          _buildTimeslotSection("Night","(7:00 pm - 09:00 pm)"),



        ],
      ),
    ));
  }


  Widget _buildTimeslotSection(String timeslot,timings) {
  var screenheight = MediaQuery.of(context).size.height;
  var screenwidth = MediaQuery.of(context).size.width;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Container(
          height: screenheight * 0.07,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: screenheight * 0.06,
                width: screenwidth * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFF681E1E),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '    $timeslot  $timings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenwidth * 0.04),
              GestureDetector(
                onTap: () => _addNewSeats(timeslot),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color.fromARGB(255, 220, 154, 55),
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Color(0xFF681E1E),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      SizedBox(height: screenheight * 0.03),
      Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection(currentDate).doc(timeslot).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.data!.exists) {
              _createDefaultDocument(timeslot);
              return Center(child: CircularProgressIndicator());
            }

            var seatData = snapshot.data!['seats'] ?? [];
            return Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                height: screenheight * 0.33, // Fixed height for the scrollable container
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 220, 154, 55),
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: Colors.grey, width: 1),
                ),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    itemCount: seatData.length,
                    itemBuilder: (context, index) {
                      bool isSeatApproved =
                          seatData[index]["status"] == "Approved";
                      Color seatColor = _getSeatColor(seatData[index]["status"]);

                      return GestureDetector(
                        onDoubleTap: isSeatApproved
                            ? () => _onDoubleTap(index, seatData, timeslot)
                            : null, // Only double-tap if the seat is approved
                        onTap: isSeatApproved
                            ? null // Prevent tap if the seat is approved
                            : () => _showApprovalDialog(index, seatData, timeslot),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: seatColor,
                            borderRadius: BorderRadius.circular(20),
                            border: isSeatApproved
                                ? Border.all(color: Colors.blue, width: 2)
                                : null, // Grey border for unclickable seats
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(height: screenheight*0.025,),
    ],
  );
}


  // Create a default document in Firestore for each timeslot if it doesn't exist
  void _createDefaultDocument(String timeslot) async {
    List<Map<String, dynamic>> seats = List.generate(
      20, // Assume there are initially 20 seats
      (index) => {
        'status': 'Pending',
        'name': '',
        'randomNumber': '',
      },
    );
    await deleteYesterdayCollection();

    await _firestore.collection(currentDate).doc(timeslot).set({
      'seats': seats,
    });

  }

  // Add 5 new seats to the timeslot in Firestore
  void _addNewSeats(String timeslot) async {
     
    DocumentSnapshot snapshot = await _firestore
        .collection(currentDate)
        .doc(timeslot)
        .get();

    if (snapshot.exists) {
      List seats = snapshot['seats'];

      // Add 5 new seats to the list
      for (int i = 0; i < 5; i++) {
        seats.add({
          'status': 'Pending',
          'name': '',
          'randomNumber': '',
        });
      }

      // Update Firestore with the new seat list
      await _firestore.collection(currentDate).doc(timeslot).update({
        'seats': seats,
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF681E1E),
         // margin: EdgeInsets.only(left: 20),
          
          content: Text('Seats updated successfully !!!',style: TextStyle(color: const Color.fromARGB(255, 220, 154, 55),fontWeight: FontWeight.bold),),
          duration: Duration(seconds: 2),
        ),
      );
    



    }
  }

  // Show the dialog for admin to approve or remove a seat
  _showApprovalDialog(int index, List seats, String timeslot) {
    TextEditingController nameController = TextEditingController();
    String randomNumber = seats[index]["randomNumber"];
    String name = seats[index]["name"];
    nameController.text = name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manage Seat ${index + 1}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Customer Name: $name',overflow: TextOverflow.ellipsis,maxLines: 1,),
            //   TextField(
            //   controller: nameController, // Ensure the TextField uses the controller
            //   decoration: InputDecoration(
            //     labelText: 'Customer Name',
            //   ),
            // ),
              SizedBox(height: 10),
              Text('Random Number: $randomNumber',overflow: TextOverflow.ellipsis,maxLines: 1,),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  seats[index] = {
                    "status": "Approved",
                    "name": nameController.text,
                    "randomNumber": randomNumber
                  };
                });

                // Save the updated booking status in Firestore
                _firestore.collection(currentDate).doc(timeslot).update({
                  'seats': seats,
                });
                Navigator.of(context).pop();
              },
              child: Text('Approve'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  seats[index] = {
                    "status": "Removed",
                    "name": '',
                    "randomNumber": ''
                  };
                });

                // Remove the booking in Firestore
                _firestore.collection(currentDate).doc(timeslot).update({
                  'seats': seats,
                });
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  // Handle double-tap to change the color to pink if the seat is green (Approved)
  _onDoubleTap(int index, List seats, String timeslot) {
    if (seats[index]["status"] == "Approved") {
      setState(() {
        seats[index]["status"] = "Completed"; // Custom status for pink
      });

      // Update Firestore with the new status
      _firestore.collection(currentDate).doc(timeslot).update({
        'seats': seats,
      });
    }
  }

  Future<void> deleteYesterdayCollection() async {
  // Get yesterday's date in the format 'yyyy-MM-dd'
  String yesterday = DateTime.now().subtract(Duration(days: 1)).toIso8601String().split('T')[0];

  // Reference to the collection based on yesterday's date
  CollectionReference collection = FirebaseFirestore.instance.collection(yesterday);

  // Get all documents in the collection
  QuerySnapshot snapshot = await collection.get();

  // Check if the collection has documents
  if (snapshot.docs.isNotEmpty) {
    // Iterate through the documents and delete them
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
    print("Yesterday's collection has been deleted.");
  } else {
    print("No documents found in yesterday's collection.");
  }
}



  // Get the color of the seat based on its status
  Color _getSeatColor(String status) {
    switch (status) {
      case 'Requested':
        return const Color.fromARGB(255, 229, 225, 10);
      case 'Approved':
        return Colors.blue;
      case 'Removed':
        return Colors.red;
      case 'Completed': // Add case for pink color
        return Colors.green;
      default:
        return Colors.grey; // Pending status
    }
  }
}




////////////////////////////////////////////////////////////////////////inp///////////////////////////////


class CustomerPage extends StatefulWidget {
  final String userId;

  CustomerPage({required this.userId});

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentDate = DateTime.now().toString().substring(0, 10); // Get current date
  int _selectedIndex = 0; // Index for the selected timeslot

  // List of timeslot names
  final List<String> _timeslots = ["Morning", "Noon", "Evening", "Night"];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        
        body: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),

Padding(
  padding: EdgeInsets.only(left: 16, right: 16),
  child: Container(
    height: screenHeight * 0.23,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), 
          offset: Offset(0, 4), 
          blurRadius: 6, 
          spreadRadius: 1, 
        ),
      ],
      borderRadius: BorderRadius.circular(25),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        children: [
          // Background image with blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0), // Apply blur effect
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/llll.jpeg'), // Your image path
                    fit: BoxFit.cover, // Make sure the image covers the entire container
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          // You can add additional content here, if needed
        ],
      ),
    ),
  ),
),
           SizedBox(height: screenHeight * 0.05),
                     Padding(padding: EdgeInsets.only(left: 16,right: 16),
            child: Container(
              decoration: BoxDecoration(
                 boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ], 
                 color: const Color.fromARGB(255, 220, 154, 55),
                 //color: Color(0xFFF0E0D6),
                 borderRadius: BorderRadius.circular(20)
              ),
              height: screenHeight*0.18,
             
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                
                    Padding(padding: EdgeInsets.only(left: 16,right: 16),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                         Row(children:[ 
                         CircleAvatar(radius: 10,backgroundColor: Colors.grey,),
                         SizedBox(width: screenWidth*0.03,),
                         Text('Available',style: TextStyle(fontWeight: FontWeight.bold),)
                         ]),
                      Row(children:[ 
                        CircleAvatar(radius: 10,backgroundColor: Color.fromARGB(255, 229, 225, 10),),
                        SizedBox(width: screenWidth*0.03,),
                        Text('Requested',style: TextStyle(fontWeight: FontWeight.bold),)
                        ]),]),
                    ),
                
                    SizedBox(height: screenHeight*0.03,),
                
                       Padding(padding: EdgeInsets.only(left: 16,right: 16),
                         child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                         Row(children:[ 
                         CircleAvatar(radius: 10,backgroundColor: Colors.blue,),
                         SizedBox(width: screenWidth*0.03,),
                         Text('Approved',style: TextStyle(fontWeight: FontWeight.bold),)
                         ]),
                                         Row(children:[ 
                                           CircleAvatar(radius: 10,backgroundColor: Colors.green,),
                                           SizedBox(width: screenWidth*0.03,),
                                           Text('Completed',style: TextStyle(fontWeight: FontWeight.bold),)
                                           ]),]),
                       ),
                       SizedBox(height: screenHeight*0.03,),
                          
                          
                          Padding(padding: EdgeInsets.only(left: 45,right: 16),child: Align(alignment: Alignment.centerLeft,
                            child: Row(
                              children:[ 
                              
                              CircleAvatar(radius: 10,backgroundColor: Colors.red,),
                              SizedBox(width: screenWidth*0.03,),
                              Text('Rejected',style: TextStyle(fontWeight: FontWeight.bold),)
                              ])),),
          ]),
              ),
            ),
          ),
                      SizedBox(height: screenHeight * 0.05),
            // Timeslot Selection Container (replacing BottomNavigationBar)
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Container(
                padding: EdgeInsets.only(left: 15,right: 15),
                height: 60,
                decoration: BoxDecoration(
                   boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
                   color: Color(0xFF681E1E),
                   borderRadius: BorderRadius.circular(40)
                ),
               
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_timeslots.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });

                        String timing;
            switch (_timeslots[index]) {
              case "Morning":
                timing = "From 6:00 AM To 10:00 AM";
                break;
              case "Noon":
                timing = "From 10:00 AM To 4:00 PM";
                break;
              case "Evening":
                timing = "From 4:00 PM To 7:00 PM";
                break;
              case "Night":
                timing = "From 7:00 PM To 10:00 PM";
                break;
              default:
                timing = "Unknown";
            }

            // Show a Snackbar with the selected timeslot and timing
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Color(0xFF681E1E),
                content: Text(
                    '${_timeslots[index]} ($timing)'

                    ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                    
                    ),
                duration: Duration(seconds: 2),
              ),
            );

                      },
              
                      child:  Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  border: _selectedIndex == index
                      ? Border(bottom: BorderSide(color: const Color.fromARGB(255, 220, 154, 55), width: 1.5)) // Underline when selected
                      : null, // No border when not selected
                ),
                child: Text(
                  _timeslots[index],
                  style: TextStyle(
                    color: _selectedIndex == index ? const Color.fromARGB(255, 220, 154, 55) : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold, // Keep the bold text
                  ),
                ),
              ),
              
              
                    );
                  }),
                ),
              ),
            ),
            _buildTimeslotSection(_timeslots[_selectedIndex]),
          ],
        ),
      ),
    );
  }

  // Function to build the UI for each timeslot section (Morning, Noon, etc.)
  Widget _buildTimeslotSection(String timeslot) {
    var screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection(currentDate).doc(timeslot).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: CircularProgressIndicator());
        }

        var seatData = snapshot.data!['seats'] ?? [];

        return Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
            
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: seatData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: seatData[index]["status"] == "Pending"
                        ? () => _showBookingDialog(index, seatData, timeslot)
                        : null,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                         boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
                        color: _getSeatColor(seatData[index]["status"]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Show the booking dialog for customers to book a seat
  _showBookingDialog(int index, List seats, String timeOfDay) {
    TextEditingController nameController = TextEditingController();
    String randomNumber = _generateRandomNumber(); // Generate a random number

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 220, 154, 55),
          title: Text('Book Slot ${index + 1}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Enter your name', labelStyle: TextStyle(fontSize: 13, color: const Color.fromARGB(255, 139, 12, 12), fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Text('Random Number: $randomNumber', style: TextStyle(fontSize: 13, color: const Color.fromARGB(255, 139, 12, 12), fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  seats[index] = {
                    "status": "Requested", // Change the status to Requested
                    "name": nameController.text,
                    "randomNumber": randomNumber, // Save the random number
                  };
                });

                // Save the booking in Firestore
                _firestore.collection(currentDate).doc(timeOfDay).update({
                  'seats': seats,
                });

                // RandomNumberPage(
                //     name: nameController.text,
                //     randomNumber: randomNumber,
                //     date: currentDate,
                //     adminNumber: "9999999999",
                //   ),

                Navigator.of(context).pop(); // Close the dialog


                Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return RandomNumberPage(
                    name: nameController.text,
                    randomNumber: randomNumber,
                    date: currentDate,
                    adminNumber: "9999999999",
                  );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeIn; // or any other curve
      var curveAnimation = CurvedAnimation(parent: animation, curve: curve);

      return SlideTransition(position: animation.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero)), child: child);
    },
  ),
);



              },
              child: Text('Book Seat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Generate a random number for the customer
  String _generateRandomNumber() {
    var rng = Random();
    return (rng.nextInt(10000) + 1000).toString(); // Generate a 4-digit random number
  }

  // Get the color of the seat based on its status
  Color _getSeatColor(String status) {
    switch (status) {
      case 'Requested':
        return const Color.fromARGB(255, 229, 225, 10);
      case 'Approved':
        return Colors.blue;
      case 'Removed':
        return Colors.red;
      case 'Completed':
        return Colors.green; // Completed status color
      default:
        return Colors.grey; // Pending status
    }
  }

  // Widget to show the status badges (Available, Requested, etc.)
  Widget _statusBadge(String text, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundColor: color),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

