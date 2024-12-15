// import 'package:flutter/material.dart';

// class StatusOfBooking extends StatefulWidget{
//   final String userId;

//   StatusOfBooking({required this.userId});





//   @override
//   State<StatusOfBooking> createState() => _StatusOfBookingState();
// }

// class _StatusOfBookingState extends State<StatusOfBooking> {
//   @override
//   Widget build(BuildContext context) {
//     var screenwidth = MediaQuery.of(context).size.height;
//     var screenheight = MediaQuery.of(context).size.width;
    
//     return Scaffold(
//        resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,

//       body:Center(child: Column(children: [

//         SizedBox(height:screenheight*0.45),

//         Container(
//           child:Text('Your current status !!!',style:TextStyle(fontSize: 16,color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold,)),
//         ),

//         SizedBox(height: screenheight*0.3,),

//         Padding(padding:EdgeInsets.symmetric(horizontal: 20),child:Container(
//           height: screenheight*0.7,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: const Color.fromARGB(255, 224, 158, 88),
//             ) ,
//             child:Column(
//               children: [
//                 SizedBox(height: screenheight*0.05,),
                

//                 Container(
//                   child:
//                   Row(mainAxisAlignment: MainAxisAlignment.center,
//                     children:[
//                     Text('Booking Details',style:TextStyle(fontSize: 16,color:const Color.fromARGB(255, 127, 120, 120),fontWeight: FontWeight.bold)),
//                     SizedBox(width: screenwidth*0.01),
//                    // Icon(Icons.cut,color: Colors.white,size: 20,),
//               ]),),
//                 SizedBox(height: screenheight*0.08,),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child:Text('   Your Name           :   ',style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
//                 ),
//                 SizedBox(height: screenheight*0.05,),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child:Text('   Booked Date        :   ',style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
//                 ),
//                 SizedBox(height: screenheight*0.05,),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child:Text('   Booked Number  :   ',style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
//                 ),
//                  SizedBox(height: screenheight*0.05,),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child:Text('   Status    :   ',style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
//                 ),

//               ],
//             )
            
//                ),
//         ),
//         SizedBox(height: screenheight*0.3,),

//        GestureDetector(
//         onTap:(){},
//         child:Padding(padding:EdgeInsets.symmetric(horizontal: 13),child:Container(
          
//           height: screenheight*0.15,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 74, 25, 7),
//             borderRadius: BorderRadius.circular(40)
//           ),
//           child:Center(child: Text('Go to Payment',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),))
//         )
//        )


//       )],),)
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hair/payment.dart';

class StatusOfBooking extends StatefulWidget {
  final String userId;

  StatusOfBooking({required this.userId});

  @override
  State<StatusOfBooking> createState() => _StatusOfBookingState();
}

class _StatusOfBookingState extends State<StatusOfBooking> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch user data from Firestore based on userId
  Future<DocumentSnapshot> _fetchUserData() async {
    try {
      // Fetch user details from Firestore using userId
      DocumentSnapshot snapshot = await _firestore
          .collection('users')  // Collection name
          .doc(widget.userId)   // Document ID is userId
          .get();

      if (snapshot.exists) {
        return snapshot;  // Return snapshot if data exists
      } else {
        throw Exception('No user data found');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();  // Show loading indicator
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));  // Show error if occurs
            }

            if (snapshot.hasData && snapshot.data != null) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;

              // Display the user data if available
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: screenheight * 0.2),
                    Container(
                      child: Text(
                        'Your current status !!!',
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 74, 25, 7),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: screenheight * 0.15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: screenheight * 0.3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 224, 158, 88),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: screenheight * 0.005),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: screenheight*0.1,),
                                  Text('Booking Details',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 127, 120, 120),
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: screenheight * 0.008),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '   Date              :   ${userData['date']}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 74, 25, 7),
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: screenheight * 0.03),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '   Email            :   ${userData['email']}',
                                  overflow: TextOverflow.ellipsis, 
                                   maxLines: 1,
   
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 74, 25, 7),
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: screenheight * 0.03),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '   BR Number  :   ${userData['initial_random_number']}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 74, 25, 7),
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenheight * 0.15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment_Page()));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: Container(
                            height: screenheight * 0.07,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 74, 25, 7),
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                              child: Text(
                                'Go to Payment',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text('No user data found.'));
          },
        ),
      ),
    );
  }
}
