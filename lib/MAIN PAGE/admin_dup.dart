
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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


class AdminPage_dup extends StatefulWidget {
  @override
  _AdminPage_dupState createState() => _AdminPage_dupState();
}

class _AdminPage_dupState extends State<AdminPage_dup> {
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
                      StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection(currentDate).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Stack(
                            children: [
                              Icon(Icons.notifications, color: Colors.white),
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
                            Icon(Icons.notifications, color: Colors.white),
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

                      Switch(
                        
                        inactiveThumbColor: Color(0xFF681E1E),
                        inactiveTrackColor: Colors.white,
                        activeColor: const Color.fromARGB(255, 220, 154, 55),
            value: isOn,
            onChanged: _toggleSwitch,
          ),

                    ],
                  )
                ),
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




Container(
  width: double.infinity,
  height: screenheight * 0.1,
  decoration: BoxDecoration(
    color: Color.fromARGB(255, 220, 154, 55),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      GestureDetector(
        onTap: () {
          setState(() {
            selectedSection = 0; // Morning
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              color: selectedSection == 0 ? Colors.blue : Colors.white,
            ),
            Text(
              'Morning',
              style: TextStyle(
                color: selectedSection == 0 ? Colors.blue : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedSection = 1; // Noon
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              color: selectedSection == 1 ? Colors.blue : Colors.white,
            ),
            Text(
              'Noon',
              style: TextStyle(
                color: selectedSection == 1 ? Colors.blue : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedSection = 2; // Evening
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              color: selectedSection == 2 ? Colors.blue : Colors.white,
            ),
            Text(
              'Evening',
              style: TextStyle(
                color: selectedSection == 2 ? Colors.blue : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedSection = 3; // Night
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              color: selectedSection == 3 ? Colors.blue : Colors.white,
            ),
            Text(
              'Night',
              style: TextStyle(
                color: selectedSection == 3 ? Colors.blue : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
Column(
  children: [
    // Display ticket list for the selected section (Morning, Noon, Evening, Night)
    if (selectedSection == 0) _buildTicketList("Morning"),
    if (selectedSection == 1) _buildTicketList("Noon"),
    if (selectedSection == 2) _buildTicketList("Evening"),
    if (selectedSection == 3) _buildTicketList("Night"),
  ],
)



        ],
      ),
    ));
  }
 Widget _buildTicketList(String timeslot) {
  return Padding(
    padding: EdgeInsets.all(16),
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
            height: 300, // Adjust the height for vertical scroll
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 220, 154, 55),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Enable vertical scrolling
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                shrinkWrap: true, // Disable scrolling for the inner GridView
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 seats per row
                  mainAxisSpacing: 16.0, // Space between rows
                  crossAxisSpacing: 16.0, // Space between columns
                ),
                itemCount: seatData.length,
                itemBuilder: (context, index) {
                  bool isSeatApproved = seatData[index]["status"] == "Approved";
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