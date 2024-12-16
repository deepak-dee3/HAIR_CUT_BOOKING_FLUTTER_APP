// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:hair/forget_password.dart';
// import 'package:hair/log_ui.dart';
// import 'dart:math';
// import 'package:hair/login.dart';
// import 'package:hair/payment.dart';
// import 'package:hair/random_number_page.dart';
// import 'package:hair/signin_login.dart';
// import 'package:hair/signup_login.dart';
// import 'package:hair/status_of_booking.dart'; // for generating random numbers



// // AdminPage: Admin manages the seats
// // class AdminPage extends StatefulWidget {
// //   @override
// //   _AdminPageState createState() => _AdminPageState();
// // }

// // class _AdminPageState extends State<AdminPage> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         actions: [
// //           GestureDetector(child: Icon(Icons.blender_outlined)
// //             ,onTap: (){
// //               // Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthPage()));
// //                Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthService()));


// //            // Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInPage()));
// //            // Navigator.push(context, MaterialPageRoute(builder: (context)=>RandomNumberPage()));
// //           },),
// //            GestureDetector(child: Icon(Icons.password)
// //             ,onTap: (){

// //             Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
// //           },)
// //         ],
// //         leading: GestureDetector(child: Icon(Icons.abc),
// //           onTap: (){
// //           //Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerPage()));
// //         },),
// //         title: Text('Admin Seat Management'),
// //       ),
// //       body: ListView(
// //         children: [
// //           _buildTimeslotSection("Morning"),
// //           _buildTimeslotSection("Noon"),
// //           _buildTimeslotSection("Evening"),
// //           _buildTimeslotSection("Night"),
// //         ],
// //       ),
// //     );
// //   }

// //   // Function to build the UI for each timeslot section (Morning, Noon, etc.)
// //   Widget _buildTimeslotSection(String timeslot) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             '$timeslot: 20 seats',
// //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //           ),
// //           StreamBuilder<DocumentSnapshot>(
// //             stream: _firestore
// //                 .collection(currentDate)
// //                 .doc(timeslot)
// //                 .snapshots(),
// //             builder: (context, snapshot) {
// //               if (!snapshot.hasData) {
// //                 return Center(child: CircularProgressIndicator());
// //               }

// //               if (!snapshot.data!.exists) {
// //                 _createDefaultDocument(timeslot);
// //                 return Center(child: CircularProgressIndicator());
// //               }

// //               var seatData = snapshot.data!['seats'] ?? [];
// //               return Column(
// //                 children: [
// //                   GridView.builder(
// //                     shrinkWrap: true,
// //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                       crossAxisCount: 5,
// //                       mainAxisSpacing: 8.0,
// //                       crossAxisSpacing: 8.0,
// //                     ),
// //                     itemCount: seatData.length,
// //                     itemBuilder: (context, index) {
// //                       bool isSeatApproved =
// //                           seatData[index]["status"] == "Approved";

// //                       return GestureDetector(
// //                         // onDoubleTap: isSeatApproved
// //                         //     ? () => _onDoubleTap(index, seatData, timeslot)
// //                         //     : null,

                    
                        
                       
// //                         onTap: isSeatApproved
// //                             ? null // Prevent action if the seat is approved
// //                             : () => _showApprovalDialog(index, seatData, timeslot),
// //                         child: Container(
// //                           alignment: Alignment.center,
// //                           decoration: BoxDecoration(
// //                             color: _getSeatColor(seatData[index]["status"]),
// //                             borderRadius: BorderRadius.circular(20),
// //                             border: isSeatApproved
// //                                 ? Border.all(color: Colors.grey, width: 2)
// //                                 : null, // Grey border for unclickable seats
// //                           ),
// //                           child: Text(
// //                             '${index + 1}',
// //                             style: TextStyle(
// //                               color: isSeatApproved
// //                                   ? Colors.grey
// //                                   : Colors.white, // Grey text if the seat is unclickable
// //                               fontSize: 16,
// //                             ),
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                   ElevatedButton.icon(
// //                     onPressed: () => _addNewSeats(timeslot),
// //                     icon: Icon(Icons.add),
// //                     label: Text("Add 5 seats"),
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Create a default document in Firestore for each timeslot if it doesn't exist
// //   void _createDefaultDocument(String timeslot) async {
// //     List<Map<String, dynamic>> seats = List.generate(
// //       20, // Assume there are initially 20 seats
// //       (index) => {
// //         'status': 'Pending',
// //         'name': '',
// //         'randomNumber': '',
// //       },
// //     );

// //     await _firestore.collection(currentDate).doc(timeslot).set({
// //       'seats': seats,
// //     });
// //   }

// //   // Add 5 new seats to the timeslot in Firestore
// //   void _addNewSeats(String timeslot) async {
// //     DocumentSnapshot snapshot = await _firestore
// //         .collection(currentDate)
// //         .doc(timeslot)
// //         .get();

// //     if (snapshot.exists) {
// //       List seats = snapshot['seats'];

// //       // Add 5 new seats to the list
// //       for (int i = 0; i < 5; i++) {
// //         seats.add({
// //           'status': 'Pending',
// //           'name': '',
// //           'randomNumber': '',
// //         });
// //       }

// //       // Update Firestore with the new seat list
// //       await _firestore.collection(currentDate).doc(timeslot).update({
// //         'seats': seats,
// //       });
// //     }
// //   }

// //   // Show the dialog for admin to approve or remove a seat
// //   _showApprovalDialog(int index, List seats, String timeslot) {
// //     TextEditingController nameController = TextEditingController();
// //     String randomNumber = seats[index]["randomNumber"];
// //     String name = seats[index]["name"];

// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('Manage Seat ${index + 1}'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
              
// //                Text('Customer Name: $name'),
// //               SizedBox(height: 10),
// //               Text('Random Number: $randomNumber'),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 setState(() {
// //                   seats[index] = {
// //                     "status": "Approved",
// //                     "name": nameController.text,
// //                     "randomNumber": randomNumber
// //                   };
// //                 });

// //                 // Save the updated booking status in Firestore
// //                 _firestore.collection(currentDate).doc(timeslot).update({
// //                   'seats': seats,
// //                 });
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('Approve'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 setState(() {
// //                   seats[index] = {
// //                     "status": "Removed",
// //                     "name": '',
// //                     "randomNumber": ''
// //                   };
// //                 });

// //                 // Remove the booking in Firestore
// //                 _firestore.collection(currentDate).doc(timeslot).update({
// //                   'seats': seats,
// //                 });
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('Remove'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }



  

// //   // Get the color of the seat based on its status
// //   Color _getSeatColor(String status) {
// //     switch (status) {
// //       case 'Requested':
// //         return Colors.orange;
// //       case 'Approved':
// //         return Colors.green;
// //       case 'Removed':
// //         return Colors.red;
      
      
// //       default:
// //         return Colors.blue; // Pending status
// //     }
// //   }
// // }
// class AdminPagedup extends StatefulWidget {
//   @override
//   _AdminPagedupState createState() => _AdminPagedupState();
// }

// class _AdminPagedupState extends State<AdminPagedup> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

//   @override
//   Widget build(BuildContext context) {
//      var screenheight = MediaQuery.of(context).size.height;
//     var screenwidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(onTap:(){
//           Navigator.push(context, MaterialPageRoute(builder: (context) => LogInUpPage()));

//         }
//           ,child: Icon(Icons.abc_outlined)),
//         actions: [
//           GestureDetector(
//             child: Icon(Icons.login),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => LogInUpPage()));
//             },
//           ),
//           GestureDetector(
//             child: Icon(Icons.sign_language),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => SignInUpPage()));
//             },
//           ),
//           GestureDetector(
//             child: Icon(Icons.blender_outlined),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => AuthService()));
//             },
//           ),
//           GestureDetector(
//             child: Icon(Icons.password),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => Payment_Page()));
//             },
//           )
//         ],
//         title: Text('Admin Seat Management'),
//       ),
//       body: ListView(
//         children: [
//           Padding(padding: EdgeInsets.only(left: 16,right: 16),
//             child: Container(
//               height: screenheight*0.13,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: Color(0xFF681E1E),
//               ),
//               child: Align(alignment: Alignment.center,
//                 child: Container(
//                   child:Text('Hello , Buddy',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: screenheight*0.04,),

//           Padding(padding: EdgeInsets.only(left: 16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
            
//                     Chip(chipAnimationStyle: ChipAnimationStyle(),
//                     padding: EdgeInsets.symmetric(horizontal: 2),
//                     backgroundColor: Colors.grey,
//                     shape: RoundedRectangleBorder(
                      
//     borderRadius: BorderRadius.circular(20), // Set border radius to 20
//   ),
//                       avatar:Icon(Icons.circle_rounded,color: Colors.grey,) ,
//                       label: Text('Not Booked')),

                      
//                        Chip(chipAnimationStyle: ChipAnimationStyle(),
//                     padding: EdgeInsets.symmetric(horizontal: 2),
//                     backgroundColor: const Color.fromARGB(255, 169, 154, 21),
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide.none,
                      
//     borderRadius: BorderRadius.circular(20), // Set border radius to 20
//   ),
//                       avatar:Icon(Icons.circle_rounded,color: Colors.grey,) ,
//                       label: Text('Requested'))
            
//                   ],
//                 ),
//                  Chip(chipAnimationStyle: ChipAnimationStyle(),
//                     padding: EdgeInsets.symmetric(horizontal: 2),
//                     backgroundColor: Colors.grey,
//                     shape: RoundedRectangleBorder(
                      
//     borderRadius: BorderRadius.circular(20), // Set border radius to 20
//   ),
//                       avatar:Icon(Icons.circle_rounded,color: Colors.grey,) ,
//                       label: Text('Not Booked')),
//                        Chip(chipAnimationStyle: ChipAnimationStyle(),
//                     padding: EdgeInsets.symmetric(horizontal: 2),
//                     backgroundColor: Colors.grey,
//                     shape: RoundedRectangleBorder(
                      
//     borderRadius: BorderRadius.circular(20), // Set border radius to 20
//   ),
//                       avatar:Icon(Icons.circle_rounded,color: Colors.grey,) ,
//                       label: Text('Not Booked')),
//                        Chip(chipAnimationStyle: ChipAnimationStyle(),
//                     padding: EdgeInsets.symmetric(horizontal: 2),
//                     backgroundColor: Colors.grey,
//                     shape: RoundedRectangleBorder(
                      
//     borderRadius: BorderRadius.circular(20), // Set border radius to 20
//   ),
//                       avatar:Icon(Icons.circle_rounded,color: Colors.grey,) ,
//                       label: Text('Not Booked')),
//               ],
//             ),
//           ),
//           SizedBox(height: screenheight*0.04,),

//           _buildTimeslotSection("Morning"),
//           _buildTimeslotSection("Noon"),
//           _buildTimeslotSection("Evening"),
//           _buildTimeslotSection("Night"),
//         ],
//       ),
//     );
//   }

//   // Function to build the UI for each timeslot section (Morning, Noon, etc.)
//   Widget _buildTimeslotSection(String timeslot) {
//      var screenheight = MediaQuery.of(context).size.height;
//     var screenwidth = MediaQuery.of(context).size.width;
//     return Column(
//       children:[

        
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
             
//             //  Text(
//             //    '$timeslot: 20 seats',
//             //    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             //  ),
           
//              Padding(padding: EdgeInsets.only(left: 12,right: 16),
//                child: Container(
//                 height: screenheight*0.07,
//                 width: double.infinity,
//                 // decoration: BoxDecoration(
//                 //   color: Colors.white
//                 // ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: screenheight*0.06,
//                       width: screenwidth*0.5,
//                       decoration: BoxDecoration( borderRadius: BorderRadius.circular(18),
//                         color: Color(0xFF681E1E),),
//                         child: Align(alignment: Alignment.centerLeft,
//                           child: Text('    $timeslot',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                      
//                       //width: double.infinity,
                     
//                     ),
//                     //  Container(
//                     //   height: screenheight*0.05,
//                     //   width: screenwidth*0.4,
                      
//                     //   //width: double.infinity,
//                     //   color: Colors.white,
//                     //   child: Text('Timings : '),
//                     // )
//                   ],
//                 ),
//                ),
//              ),
//              SizedBox(height: screenheight*0.03,),
//              Padding(padding: EdgeInsets.only(left: 16,right: 16),
//                child: StreamBuilder<DocumentSnapshot>(
//                  stream: _firestore
//                      .collection(currentDate)
//                      .doc(timeslot)
//                      .snapshots(),
//                  builder: (context, snapshot) {
//                    if (!snapshot.hasData) {
//                      return Center(child: CircularProgressIndicator());
//                    }
                 
//                    if (!snapshot.data!.exists) {
//                      _createDefaultDocument(timeslot);
//                      return Center(child: CircularProgressIndicator());
//                    }
                 
//                    var seatData = snapshot.data!['seats'] ?? [];
//                    return Column(
//                      children: [
//                        GridView.builder(
//                          shrinkWrap: true,
//                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                            crossAxisCount: 5,
//                            mainAxisSpacing: 16.0,
//                            crossAxisSpacing: 16.0,
//                          ),
//                          itemCount: seatData.length < 14 ? seatData.length : 15,//seatData.length,
//                          itemBuilder: (context, index) {
//                            bool isSeatApproved =
//                                seatData[index]["status"] == "Approved";
//                            Color seatColor = _getSeatColor(seatData[index]["status"]);
                 
//                            return GestureDetector(
//                              onDoubleTap: isSeatApproved
//                                  ? () => _onDoubleTap(index, seatData, timeslot)
//                                  : null, // Only double-tap if the seat is approved
//                              onTap: isSeatApproved
//                                  ? null // Prevent tap if the seat is approved
//                                  : () => _showApprovalDialog(index, seatData, timeslot),
//                              child: Container(
//                                alignment: Alignment.center,
//                                decoration: BoxDecoration(
//                                  color: seatColor,
//                                  borderRadius: BorderRadius.circular(20),
//                                  border: isSeatApproved
//                                      ? Border.all(color: Colors.grey, width: 2)
//                                      : null, // Grey border for unclickable seats
//                                ),
//                                child: Text(
//                                  '${index + 1}',
//                                  style: TextStyle(
//                                    color: isSeatApproved
//                                        ? Colors.grey
//                                        : Colors.white, // Grey text if the seat is unclickable
//                                    fontSize: 16,
//                                  ),
//                                ),
//                              ),
//                            );
//                          },
//                        ),
//                        ElevatedButton.icon(
//                          onPressed: () => _addNewSeats(timeslot),
//                          icon: Icon(Icons.add),
//                          label: Text("Add 5 seats"),
//                        ),
//                      ],
//                    );
//                  },
//                ),
//              ),
//            ],
//          ),
//     ]);
//   }

//   // Create a default document in Firestore for each timeslot if it doesn't exist
//   void _createDefaultDocument(String timeslot) async {
//     List<Map<String, dynamic>> seats = List.generate(
//       20, // Assume there are initially 20 seats
//       (index) => {
//         'status': 'Pending',
//         'name': '',
//         'randomNumber': '',
//       },
//     );

//     await _firestore.collection(currentDate).doc(timeslot).set({
//       'seats': seats,
//     });
//   }

//   // Add 5 new seats to the timeslot in Firestore
//   void _addNewSeats(String timeslot) async {
//     DocumentSnapshot snapshot = await _firestore
//         .collection(currentDate)
//         .doc(timeslot)
//         .get();

//     if (snapshot.exists) {
//       List seats = snapshot['seats'];

//       // Add 5 new seats to the list
//       for (int i = 0; i < 5; i++) {
//         seats.add({
//           'status': 'Pending',
//           'name': '',
//           'randomNumber': '',
//         });
//       }

//       // Update Firestore with the new seat list
//       await _firestore.collection(currentDate).doc(timeslot).update({
//         'seats': seats,
//       });
//     }
//   }

//   // Show the dialog for admin to approve or remove a seat
//   _showApprovalDialog(int index, List seats, String timeslot) {
//     TextEditingController nameController = TextEditingController();
//     String randomNumber = seats[index]["randomNumber"];
//     String name = seats[index]["name"];
//     nameController.text = name;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Manage Seat ${index + 1}'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Customer Name: $name',overflow: TextOverflow.ellipsis,maxLines: 1,),
//             //   TextField(
//             //   controller: nameController, // Ensure the TextField uses the controller
//             //   decoration: InputDecoration(
//             //     labelText: 'Customer Name',
//             //   ),
//             // ),
//               SizedBox(height: 10),
//               Text('Random Number: $randomNumber',overflow: TextOverflow.ellipsis,maxLines: 1,),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   seats[index] = {
//                     "status": "Approved",
//                     "name": nameController.text,
//                     "randomNumber": randomNumber
//                   };
//                 });

//                 // Save the updated booking status in Firestore
//                 _firestore.collection(currentDate).doc(timeslot).update({
//                   'seats': seats,
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Approve'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   seats[index] = {
//                     "status": "Removed",
//                     "name": '',
//                     "randomNumber": ''
//                   };
//                 });

//                 // Remove the booking in Firestore
//                 _firestore.collection(currentDate).doc(timeslot).update({
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

//   // Handle double-tap to change the color to pink if the seat is green (Approved)
//   _onDoubleTap(int index, List seats, String timeslot) {
//     if (seats[index]["status"] == "Approved") {
//       setState(() {
//         seats[index]["status"] = "Completed"; // Custom status for pink
//       });

//       // Update Firestore with the new status
//       _firestore.collection(currentDate).doc(timeslot).update({
//         'seats': seats,
//       });
//     }
//   }

//   // Get the color of the seat based on its status
//   Color _getSeatColor(String status) {
//     switch (status) {
//       case 'Requested':
//         return Colors.orange;
//       case 'Approved':
//         return Colors.green;
//       case 'Removed':
//         return Colors.grey;
//       case 'Completed': // Add case for pink color
//         return Colors.pink;
//       default:
//         return Colors.blue; // Pending status
//     }
//   }
// }


// // // Customer Page
// // class CustomerPage extends StatefulWidget {


// //   final String userId;

// //   CustomerPage({required this.userId});
  
  
// //   @override
// //   _CustomerPageState createState() => _CustomerPageState();
// // }

// // class _CustomerPageState extends State<CustomerPage> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   String currentDate = DateTime.now().toString().substring(0, 10); // Get current date

  

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Customer Seat Booking'),
// //       ),
// //       body: ListView(
// //         children: [
// //           _buildTimeslotSection("Morning"),
// //           _buildTimeslotSection("Noon"),
// //           _buildTimeslotSection("Evening"),
// //           _buildTimeslotSection("Night"),
// //         ],
// //       ),
// //     );
// //   }

// //   // Function to build the UI for each timeslot section (Morning, Noon, etc.)
// //   Widget _buildTimeslotSection(String timeslot) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             '$timeslot: 20 seats',
// //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //           ),
// //           StreamBuilder<DocumentSnapshot>(
// //             stream: _firestore
// //                 .collection(currentDate)
// //                 .doc(timeslot)
// //                 .snapshots(),
// //             builder: (context, snapshot) {
// //               if (!snapshot.hasData) {
// //                 return Center(child: CircularProgressIndicator());
// //               }

// //               if (!snapshot.data!.exists) {
// //                 return Center(child: CircularProgressIndicator());
// //               }

// //               var seatData = snapshot.data!['seats'] ?? [];
// //               return Column(
// //                 children: [
// //                   GridView.builder(
// //                     shrinkWrap: true,
// //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                       crossAxisCount: 5,
// //                       mainAxisSpacing: 8.0,
// //                       crossAxisSpacing: 8.0,
// //                     ),
// //                     itemCount: seatData.length,
// //                     itemBuilder: (context, index) {
// //                       return GestureDetector(
// //                         onTap: seatData[index]["status"] == "Pending"
// //                             ? () => _showBookingDialog(index, seatData, timeslot)
// //                             : null, // Make it unclickable if already booked
// //                         child: Container(
// //                           alignment: Alignment.center,
// //                           decoration: BoxDecoration(
// //                             color: _getSeatColor(seatData[index]["status"]),
// //                             borderRadius: BorderRadius.circular(20),
// //                           ),
// //                           child: Text(
// //                             '${index + 1}',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 16,
// //                             ),
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //   _showBookingDialog(int index, List seats, String timeOfDay) {
// //   TextEditingController nameController = TextEditingController();
// //   String randomNumber = _generateRandomNumber(); // Generate a random number

// //   String ini_ran_num = randomNumber;
// //   String cr = currentDate; 
  

// //   showDialog(
// //     context: context,
// //     builder: (context) {
// //       return AlertDialog(
// //         title: Text('Book Seat ${index + 1}'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: nameController,
// //               decoration: InputDecoration(labelText: 'Enter your name'),
// //             ),
// //             SizedBox(height: 10),
// //             Text('Random Number: $randomNumber'),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               setState(() {
// //                 seats[index] = {
// //                   "status": "Requested",
// //                   "name": nameController.text,
// //                   "randomNumber": randomNumber, // Save the random number
// //                 };
// //               });

// //               // Save the booking in Firestore
// //               _firestore.collection(currentDate).doc(timeOfDay).update({
// //                 'seats': seats,
// //               });
// //               Navigator.of(context).pop(); // Close the dialog
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => RandomNumberPage(
// //                     name: nameController.text,
// //                     randomNumber: randomNumber,
// //                     date: currentDate,
// //                     adminNumber: "9090897654",
// //                   ),
// //                 ),
// //               );
// //                FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
// //     'initial_random_number': randomNumber,
// //     'date':cr,
// //   });
// //             },
// //             child: Text('Book Seat'),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }

// // // Generate a random number for the customer
// // String _generateRandomNumber() {
// //   var rng = Random();
// //   return (rng.nextInt(10000) + 1000).toString(); // Generate a 4-digit random number
// // }


// //   // Get the color of the seat based on its status
// //   Color _getSeatColor(String status) {
// //     switch (status) {
// //       case 'Requested':
// //         return Colors.orange;
// //       case 'Approved':
// //         return Colors.green;
// //       case 'Removed':
// //         return Colors.red;
// //       default:
// //         return Colors.blue; // Pending status
// //     }
// //   }
// // }

// class CustomerPage extends StatefulWidget {
//   final String userId;

//   CustomerPage({required this.userId});

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
//         leading: GestureDetector(onTap:(){
//           Navigator.push(context, MaterialPageRoute(builder: (context) => StatusOfBooking(userId: widget.userId)));
           

//         },
//           child: Icon(Icons.book_rounded)),
//       ),
//       body: ListView(
//         children: [
//           _buildTimeslotSection("Morning"),
//           _buildTimeslotSection("Noon"),
//           _buildTimeslotSection("Evening"),
//           _buildTimeslotSection("Night"),
//         ],
//       ),
//     );
//   }

//   // Function to build the UI for each timeslot section (Morning, Noon, etc.)
//   Widget _buildTimeslotSection(String timeslot) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$timeslot: 20 seats',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           StreamBuilder<DocumentSnapshot>(
//             stream: _firestore
//                 .collection(currentDate)
//                 .doc(timeslot)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               if (!snapshot.data!.exists) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               var seatData = snapshot.data!['seats'] ?? [];
//               return Column(
//                 children: [
//                   GridView.builder(
//                     shrinkWrap: true,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 5,
//                       mainAxisSpacing: 8.0,
//                       crossAxisSpacing: 8.0,
//                     ),
//                     itemCount: seatData.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: seatData[index]["status"] == "Pending"
//                             ? () => _showBookingDialog(index, seatData, timeslot)
//                             : null, // Make it unclickable if already booked
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: _getSeatColor(seatData[index]["status"]),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '${index + 1}',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Show the booking dialog for customers to book a seat
//   _showBookingDialog(int index, List seats, String timeOfDay) {
//     TextEditingController nameController = TextEditingController();
//     String randomNumber = _generateRandomNumber(); // Generate a random number
//      String cr = currentDate; 

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
//                     "status": "Requested", // Change the status to Requested
//                     "name": nameController.text,
//                     "randomNumber": randomNumber, // Save the random number
//                   };
//                 });

//                 // Save the booking in Firestore
//                 _firestore.collection(currentDate).doc(timeOfDay).update({
//                   'seats': seats,
//                 });

//                 Navigator.of(context).pop(); // Close the dialog

               
//                  Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => RandomNumberPage(
//                   name: nameController.text,
//                   randomNumber: randomNumber,
//                   date: currentDate,
//                   adminNumber: "9999999999",
//                 ),
//               ));
//                 FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
//     'initial_random_number': randomNumber,
//     'date':cr,
//   });

//   //               FirebaseFirestore.instance.collection('users_history').doc(widget.userId).set({
    
//   //   '1':cr,
//   // });

//    final docRef = FirebaseFirestore.instance.collection('users_history').doc(widget.userId);

//                docRef.get().then((docSnapshot) async {
//                 if (docSnapshot.exists) {
//                   // Document exists, find the next field name
//                   Map<String, dynamic>? data = docSnapshot.data();

//                   if (data != null) {
//                     int nextIndex = data.keys.map((key) => int.tryParse(key) ?? 0).fold(0, (a, b) => a > b ? a : b) + 1;

//                     // Add the new date field
//                     await docRef.update({'$nextIndex': cr});
//                   }
//                 } else {
//                   // Document does not exist, create it with the first field
//                   await docRef.set({'1': cr});
//                 }
//               });

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
//         return Colors.grey;
//       case 'Completed':
//         return Colors.pink; // Completed status color
//       default:
//         return Colors.blue; // Pending status
//     }
//   }
// }
