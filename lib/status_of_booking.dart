import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusOfBooking extends StatefulWidget {
  final String userId;

  StatusOfBooking({required this.userId});

  @override
  State<StatusOfBooking> createState() => _StatusOfBookingState();
}

class _StatusOfBookingState extends State<StatusOfBooking> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch user data from Firestore based on userId
  Future<Map<String, dynamic>> _fetchUserHistory() async {
    try {
      // Fetch user details from Firestore using userId
      DocumentSnapshot snapshot = await _firestore
          .collection('users_history') // Collection name
          .doc(widget.userId) // Document ID is userId
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>; // Return user data
      } else {
        throw Exception('No user history found');
      }
    } catch (e) {
      throw Exception('Error fetching user history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
       return false;
         
      },
      child:
    Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchUserHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Show error if occurs
            }

            if (snapshot.hasData && snapshot.data != null) {
              Map<String, dynamic> userData = snapshot.data!;
              
              // Extract dates from Firestore document
              List<String> dateKeys = userData.keys.toList()
                ..sort((a, b) => int.parse(a).compareTo(int.parse(b))); // Sort by field numbers
             List<String> dates = dateKeys.map((key) => userData[key].toString()).toList();

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    Text(
                      'Your Booking History',
                      style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 74, 25, 7),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 224, 158, 88),
                              ),
                              child: Text(
                                'Booking ${index + 1}: ${dates[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 74, 25, 7),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No booking history found.',style:TextStyle(color:Colors.black)));
            }
          },
        ),
      ),
     ) );
  }
}
