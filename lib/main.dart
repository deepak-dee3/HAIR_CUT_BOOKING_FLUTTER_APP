import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hair/forget_password.dart';
import 'dart:math';

import 'package:hair/login.dart';
import 'package:hair/payment.dart';
import 'package:hair/random_number_page.dart';
import 'package:hair/signin_login.dart';
import 'package:hair/signup_login.dart'; // for generating random numbers

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminPage(),
    );
  }
}

// AdminPage: Admin manages the seats
class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(child: Icon(Icons.blender_outlined)
            ,onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthPage()));
               Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthService()));


           // Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInPage()));
           // Navigator.push(context, MaterialPageRoute(builder: (context)=>RandomNumberPage()));
          },),
           GestureDetector(child: Icon(Icons.password)
            ,onTap: (){

            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
          },)
        ],
        leading: GestureDetector(child: Icon(Icons.abc),
          onTap: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerPage()));
        },),
        title: Text('Admin Seat Management'),
      ),
      body: ListView(
        children: [
          _buildTimeslotSection("Morning"),
          _buildTimeslotSection("Noon"),
          _buildTimeslotSection("Evening"),
          _buildTimeslotSection("Night"),
        ],
      ),
    );
  }

  // Function to build the UI for each timeslot section (Morning, Noon, etc.)
  Widget _buildTimeslotSection(String timeslot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$timeslot: 20 seats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection(currentDate)
                .doc(timeslot)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.data!.exists) {
                _createDefaultDocument(timeslot);
                return Center(child: CircularProgressIndicator());
              }

              var seatData = snapshot.data!['seats'] ?? [];
              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: seatData.length,
                    itemBuilder: (context, index) {
                      bool isSeatApproved =
                          seatData[index]["status"] == "Approved";

                      return GestureDetector(
                        onTap: isSeatApproved
                            ? null // Prevent action if the seat is approved
                            : () => _showApprovalDialog(index, seatData, timeslot),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _getSeatColor(seatData[index]["status"]),
                            borderRadius: BorderRadius.circular(20),
                            border: isSeatApproved
                                ? Border.all(color: Colors.grey, width: 2)
                                : null, // Grey border for unclickable seats
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isSeatApproved
                                  ? Colors.grey
                                  : Colors.white, // Grey text if the seat is unclickable
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _addNewSeats(timeslot),
                    icon: Icon(Icons.add),
                    label: Text("Add 5 seats"),
                  ),
                ],
              );
            },
          ),
        ],
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manage Seat ${index + 1}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
               Text('Customer Name: $name'),
              SizedBox(height: 10),
              Text('Random Number: $randomNumber'),
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

  

  // Get the color of the seat based on its status
  Color _getSeatColor(String status) {
    switch (status) {
      case 'Requested':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Removed':
        return Colors.red;
      default:
        return Colors.blue; // Pending status
    }
  }
}

// Customer Page
class CustomerPage extends StatefulWidget {


  final String userId;

  CustomerPage({required this.userId});
  
  
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Seat Booking'),
      ),
      body: ListView(
        children: [
          _buildTimeslotSection("Morning"),
          _buildTimeslotSection("Noon"),
          _buildTimeslotSection("Evening"),
          _buildTimeslotSection("Night"),
        ],
      ),
    );
  }

  // Function to build the UI for each timeslot section (Morning, Noon, etc.)
  Widget _buildTimeslotSection(String timeslot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$timeslot: 20 seats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection(currentDate)
                .doc(timeslot)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.data!.exists) {
                return Center(child: CircularProgressIndicator());
              }

              var seatData = snapshot.data!['seats'] ?? [];
              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: seatData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: seatData[index]["status"] == "Pending"
                            ? () => _showBookingDialog(index, seatData, timeslot)
                            : null, // Make it unclickable if already booked
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _getSeatColor(seatData[index]["status"]),
                            borderRadius: BorderRadius.circular(20),
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
                ],
              );
            },
          ),
        ],
      ),
    );
  }
  _showBookingDialog(int index, List seats, String timeOfDay) {
  TextEditingController nameController = TextEditingController();
  String randomNumber = _generateRandomNumber(); // Generate a random number

  String ini_ran_num = randomNumber;
  String cr = currentDate; 
  

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Book Seat ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            SizedBox(height: 10),
            Text('Random Number: $randomNumber'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                seats[index] = {
                  "status": "Requested",
                  "name": nameController.text,
                  "randomNumber": randomNumber, // Save the random number
                };
              });

              // Save the booking in Firestore
              _firestore.collection(currentDate).doc(timeOfDay).update({
                'seats': seats,
              });
              Navigator.of(context).pop(); // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomNumberPage(
                    name: nameController.text,
                    randomNumber: randomNumber,
                    date: currentDate,
                    adminNumber: "9090897654",
                  ),
                ),
              );
               FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
    'initial_random_number': randomNumber,
    'date':cr,
  });
            },
            child: Text('Book Seat'),
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
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Removed':
        return Colors.red;
      default:
        return Colors.blue; // Pending status
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:hair/firebase_options.dart';



// void main() async{
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
 
//   runApp(MyApp());
// }



// Map<String, List<String>> seatStatuses = {
//   "Morning": List.generate(17, (index) => "Pending"),
//   "Noon": List.generate(17, (index) => "Pending"),
//   "Evening": List.generate(17, (index) => "Pending"),
//   "Night": List.generate(17, (index) => "Pending"),
// };

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CustomerPage(),
//     );
//   }
// }

// // Customer Page where users can request seats
// class CustomerPage extends StatefulWidget {
//   @override
//   _CustomerPageState createState() => _CustomerPageState();
// }

// class _CustomerPageState extends State<CustomerPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer Seat Booking'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0), // Set margin here
//         child: ListView(
//           children: seatStatuses.entries.map((entry) {
//             String timePeriod = entry.key;
//             List<String> seats = entry.value;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     timePeriod,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 6, // Number of columns
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                   itemCount: seats.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if (seats[index] == "Pending") {
//                             seats[index] = "Requested"; // Change to Requested
//                           }
//                         });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(seats[index]),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // Navigate to Admin Page and refresh after returning
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AdminPage()),
//           );
//           setState(() {}); // Refresh the Customer Page after Admin Page action
//         },
//         child: Icon(Icons.admin_panel_settings),
//         tooltip: 'Go to Admin Page',
//       ),
//     );
//   }

//   // Function to get color based on seat status
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Requested":
//         return Colors.orange;
//       case "Approved":
//         return Colors.yellow;
//       case "Removed":
//         return Colors.red;
//       default:
//         return Colors.blue; // Pending status
//     }
//   }
// }

// // Admin Page where admin can manage seat statuses and add new rows
// class AdminPage extends StatefulWidget {
//   @override
//   _AdminPageState createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Seat Management'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0), // Set margin here for Admin page
//         child: ListView(
//           children: seatStatuses.entries.map((entry) {
//             String timePeriod = entry.key;
//             List<String> seats = entry.value;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     timePeriod,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 6, // Number of columns
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                   itemCount: seats.length + 1, // Seats + one extra for "+"
//                   itemBuilder: (context, index) {
//                     if (index < seats.length) {
//                       return GestureDetector(
//                         onTap: () {
//                           if (seats[index] == "Requested") {
//                             _showApprovalDialog(timePeriod, index);
//                           }
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: _getStatusColor(seats[index]),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '${index + 1}',
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                         ),
//                       );
//                     } else {
//                       // "+" Icon for adding new row
//                       return GestureDetector(
//                         onTap: () {
//                           _addNewRow(timePeriod);
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Colors.grey,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Icon(Icons.add, color: Colors.white),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _resetSeatStatuses();
//         },
//         child: Icon(Icons.refresh),
//         tooltip: 'Reset All Seats',
//       ),
//     );
//   }

//   // Function to reset all seats back to "Pending"
//   void _resetSeatStatuses() {
//     setState(() {
//       seatStatuses.forEach((key, value) {
//         for (int i = 0; i < value.length; i++) {
//           value[i] = "Pending";
//         }
//       });
//     });
//   }

//   // Function to get color based on seat status
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Requested":
//         return Colors.orange;
//       case "Approved":
//         return Colors.yellow;
//       case "Removed":
//         return Colors.red;
//       default:
//         return Colors.blue; // Pending status
//     }
//   }

//   // Function to show approval dialog when admin clicks on a seat
//   void _showApprovalDialog(String timePeriod, int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Approve or Remove?'),
//           content: Text(
//               'Do you want to approve or remove seat ${index + 1} in $timePeriod?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   seatStatuses[timePeriod]![index] = "Approved";
//                 });
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop(); // Close both Admin Page and Dialog
//               },
//               child: Text('Approve'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   seatStatuses[timePeriod]![index] = "Removed";
//                 });
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop(); // Close both Admin Page and Dialog
//               },
//               child: Text('Remove'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to add a new row of seats for a given time period
//   void _addNewRow(String timePeriod) {
//     setState(() {
//       // Add 6 new "Pending" seats to the specified time period
//       seatStatuses[timePeriod]!.addAll(List.generate(6, (index) => "Pending"));
//     });
//   }
// }

/////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'dart:math'; // for generating random numbers

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CustomerPage(),
//     );
//   }
// }

// // CustomerPage: Customer books a seat
// class CustomerPage extends StatefulWidget {
//   @override
//   _CustomerPageState createState() => _CustomerPageState();
// }

// class _CustomerPageState extends State<CustomerPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer Seat Booking'),
//         leading: GestureDetector(onTap: (){
//           Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
//         },
//           child:Icon(Icons.add)),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _firestore.collection(currentDate).doc('Morning').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.data!.exists) {
//             _createDefaultDocument();
//             return Center(child: CircularProgressIndicator());
//           }

//           var seatData = snapshot.data!['seats'] ?? [];
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 6,
//               mainAxisSpacing: 8.0,
//               crossAxisSpacing: 8.0,
//             ),
//             itemCount: seatData.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () => _showBookingDialog(index, seatData),
//                 child: Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: _getSeatColor(seatData[index]["status"]),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${index + 1}',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Create a default document in Firestore if it doesn't exist
//   void _createDefaultDocument() async {
//     List<Map<String, dynamic>> seats = List.generate(
//       20, // Assume there are 20 seats
//       (index) => {
//         'status': 'Pending',
//         'name': '',
//         'randomNumber': '',
//       },
//     );

//     await _firestore.collection(currentDate).doc('Morning').set({
//       'seats': seats,
//     });
//   }

//   // Function to show a dialog for customer to enter their name and book the seat
//   _showBookingDialog(int index, List seats) {
//     TextEditingController nameController = TextEditingController();
//     String randomNumber = _generateRandomNumber();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Book Seat ${index + 1}'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Enter your name'),
//               ),
//               SizedBox(height: 10),
//               Text('Random Number: $randomNumber'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   seats[index] = {
//                     "status": "Requested",
//                     "name": nameController.text,
//                     "randomNumber": randomNumber
//                   };
//                 });

//                 // Save the booking in Firestore
//                 _firestore.collection(currentDate).doc('Morning').update({
//                   'seats': seats,
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Book Seat'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Generate a random number for the customer
//   String _generateRandomNumber() {
//     var rng = Random();
//     return (rng.nextInt(10000) + 1000).toString(); // Generate a 4-digit random number
//   }

//   // Get the color of the seat based on its status
//   Color _getSeatColor(String status) {
//     switch (status) {
//       case 'Requested':
//         return Colors.orange;
//       case 'Approved':
//         return Colors.green;
//       case 'Removed':
//         return Colors.red;
//       default:
//         return Colors.blue; // Pending status
//     }
//   }
// }

// // AdminPage: Admin approves or removes the seat request
// class AdminPage extends StatefulWidget {
//   @override
//   _AdminPageState createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Seat Management'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _firestore.collection(currentDate).doc('Morning').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.data!.exists) {
//             _createDefaultDocument();
//             return Center(child: CircularProgressIndicator());
//           }

//           var seatData = snapshot.data!['seats'] ?? [];
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 6,
//               mainAxisSpacing: 8.0,
//               crossAxisSpacing: 8.0,
//             ),
//             itemCount: seatData.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () => _showApprovalDialog(index, seatData),
//                 child: Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: _getSeatColor(seatData[index]["status"]),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${index + 1}',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Create a default document in Firestore if it doesn't exist
//   void _createDefaultDocument() async {
//     List<Map<String, dynamic>> seats = List.generate(
//       20, // Assume there are 20 seats
//       (index) => {
//         'status': 'Pending',
//         'name': '',
//         'randomNumber': '',
//       },
//     );

//     await _firestore.collection(currentDate).doc('Morning').set({
//       'seats': seats,
//     });
//   }

//   // Function to show the approval dialog for the admin to approve or remove the seat
//   _showApprovalDialog(int index, List seats) {
//     String name = seats[index]["name"];
//     String randomNumber = seats[index]["randomNumber"];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Approve or Remove Seat ${index + 1}'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Customer: $name'),
//               Text('Random Number: $randomNumber'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   seats[index]["status"] = "Approved";
//                 });

//                 // Update Firestore with the approved status
//                 _firestore.collection(currentDate).doc('Morning').update({
//                   'seats': seats,
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Approve'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   seats[index]["status"] = "Pending";
//                 });

//                 // Reset seat status to Pending
//                 _firestore.collection(currentDate).doc('Morning').update({
//                   'seats': seats,
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Remove'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Get the color of the seat based on its status
//   Color _getSeatColor(String status) {
//     switch (status) {
//       case 'Requested':
//         return Colors.orange;
//       case 'Approved':
//         return Colors.green;
//       case 'Removed':
//         return Colors.red;
//       default:
//         return Colors.blue; // Pending status
//     }
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'dart:math'; // for generating random numbers

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CustomerPage(),
//     );
//   }
// }

// // CustomerPage: Customer books a seat
// class CustomerPage extends StatefulWidget {
//   @override
//   _CustomerPageState createState() => _CustomerPageState();
// }

// class _CustomerPageState extends State<CustomerPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer Seat Booking'),
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => AdminPage()));
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Morning Period Seats
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Morning: 20 Seats',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//               stream: _firestore.collection(currentDate).doc('Morning').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.data!.exists) {
//                   _createDefaultDocument();
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var morningSeatData = snapshot.data!['seats'] ?? [];
//                 return GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 6,
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                   itemCount: morningSeatData.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => _showBookingDialog(index, morningSeatData, 'Morning'),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: _getSeatColor(morningSeatData[index]["status"]),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // Noon Period Seats
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Noon: 20 Seats',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//               stream: _firestore.collection(currentDate).doc('Noon').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.data!.exists) {
//                   _createDefaultDocument();
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var noonSeatData = snapshot.data!['seats'] ?? [];
//                 return GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 6,
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                   itemCount: noonSeatData.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => _showBookingDialog(index, noonSeatData, 'Noon'),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: _getSeatColor(noonSeatData[index]["status"]),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // Evening Period Seats
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Evening: 20 Seats',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//               stream: _firestore.collection(currentDate).doc('Evening').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.data!.exists) {
//                   _createDefaultDocument();
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var eveningSeatData = snapshot.data!['seats'] ?? [];
//                 return GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 6,
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                   itemCount: eveningSeatData.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => _showBookingDialog(index, eveningSeatData, 'Evening'),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: _getSeatColor(eveningSeatData[index]["status"]),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // Night Period Seats
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Night: 20 Seats',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//               stream: _firestore.collection(currentDate).doc('Night').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.data!.exists) {
//                   _createDefaultDocument();
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var nightSeatData = snapshot.data!['seats'] ?? [];
//                 return GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 6,
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                   itemCount: nightSeatData.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => _showBookingDialog(index, nightSeatData, 'Night'),
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: _getSeatColor(nightSeatData[index]["status"]),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Create a default document in Firestore if it doesn't exist
//   void _createDefaultDocument() async {
//     List<Map<String, dynamic>> morningSeats = List.generate(
//       20, // 20 seats for Morning
//       (index) => {
//         'status': 'Pending',
//         'name': '',
//         'randomNumber': '',
//       },
//     );

//     List<Map<String, dynamic>> noonSeats = List.generate(
//       20, // 20 seats for Noon
//       (index) => {
//         'status': 'Pending',
//         'name': '',
//         'randomNumber': '',
//       },
//     );

//     List<Map<String, dynamic>> eveningSeats = List.generate(
//       20, // 20 seats for Evening
//       (index) => {
//         'status': 'Pending',
//         'name': '',
//         'randomNumber': '',
//       },
//     );

//     List<Map<String, dynamic>> nightSeats = List.generate(
//       20, // 20 seats for Night
//       (index) => {
//         'status': 'Pending',
//         'name': '',
//         'randomNumber': '',
//       },
//     );

//     await _firestore.collection(currentDate).doc('Morning').set({
//       'seats': morningSeats,
//     });

//     await _firestore.collection(currentDate).doc('Noon').set({
//       'seats': noonSeats,
//     });

//     await _firestore.collection(currentDate).doc('Evening').set({
//       'seats': eveningSeats,
//     });

//     await _firestore.collection(currentDate).doc('Night').set({
//       'seats': nightSeats,
//     });
//   }

//   // Function to show a dialog for customer to enter their name and book the seat
//   // Function to show a dialog for customer to enter their name and book the seat
// _showBookingDialog(int index, List seats, String timeOfDay) {
//   TextEditingController nameController = TextEditingController();
//   String randomNumber = _generateRandomNumber(); // Generate a random number

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Book Seat ${index + 1}'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Enter your name'),
//             ),
//             SizedBox(height: 10),
//             Text('Random Number: $randomNumber'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 seats[index] = {
//                   "status": "Requested",
//                   "name": nameController.text,
//                   "randomNumber": randomNumber, // Save the random number
//                 };
//               });

//               // Save the booking in Firestore
//               _firestore.collection(currentDate).doc(timeOfDay).update({
//                 'seats': seats,
//               });
//               Navigator.of(context).pop();
//             },
//             child: Text('Book Seat'),
//           ),
//         ],
//       );
//     },
//   );
// }

// // Generate a random number for the customer
// String _generateRandomNumber() {
//   var rng = Random();
//   return (rng.nextInt(10000) + 1000).toString(); // Generate a 4-digit random number
// }


//   // Get the color of the seat based on its status
//   Color _getSeatColor(String status) {
//     switch (status) {
//       case 'Requested':
//         return Colors.orange;
//       case 'Approved':
//         return Colors.green;
//       case 'Removed':
//         return Colors.red;
//       default:
//         return Colors.blue; // Pending status
//     }
//   }
// }


// // AdminPage: Admin updates seat statuses
// class AdminPage extends StatefulWidget {
//   @override
//   _AdminPageState createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Seat Management'),
//       ),
//       body: SingleChildScrollView(scrollDirection: Axis.vertical,
//         child:Column(
//         children: [
//           // Admin view for each time slot (Morning, Noon, Evening, Night)
//           _buildSeatPeriod('Morning'),
//           _buildSeatPeriod('Noon'),
//           _buildSeatPeriod('Evening'),
//           _buildSeatPeriod('Night'),
//         ],
//       ),
//     ));
//   }

//   Widget _buildSeatPeriod(String period) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: StreamBuilder<DocumentSnapshot>(
//         stream: _firestore.collection(currentDate).doc(period).snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           var seatData = snapshot.data!['seats'] ?? [];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '$period: 20 Seats',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 6,
//                   mainAxisSpacing: 8.0,
//                   crossAxisSpacing: 8.0,
//                 ),
//                 itemCount: seatData.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () => _showApprovalDialog(index, seatData, period),
//                     child: Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: _getSeatColor(seatData[index]["status"]),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         '${index + 1}',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Function to show dialog for Admin to approve/remove seat status
//   // Function to show the approval dialog for the admin to approve or remove the seat
// _showApprovalDialog(int index, List seats, String timeOfDay) {
//   String name = seats[index]["name"];
//   String randomNumber = seats[index]["randomNumber"];

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Approve or Remove Seat ${index + 1}'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Customer: $name'),
//             Text('Random Number: $randomNumber'),  // Show the random number
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 seats[index]["status"] = "Approved";
//               });

//               // Update Firestore with the approved status
//               _firestore.collection(currentDate).doc(timeOfDay).update({
//                 'seats': seats,
//               });
//               Navigator.of(context).pop();
//             },
//             child: Text('Approve'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 seats[index]["status"] = "Pending";
//               });

//               // Reset seat status to Pending
//               _firestore.collection(currentDate).doc(timeOfDay).update({
//                 'seats': seats,
//               });
//               Navigator.of(context).pop();
//             },
//             child: Text('Remove'),
//           ),
//         ],
//       );
//     },
//   );
// }

//   // Get the color of the seat based on its status
//   Color _getSeatColor(String status) {
//     switch (status) {
//       case 'Requested':
//         return Colors.orange;
//       case 'Approved':
//         return Colors.green;
//       case 'Removed':
//         return Colors.red;
//       default:
//         return Colors.blue; // Pending status
//     }
//   }
// }


