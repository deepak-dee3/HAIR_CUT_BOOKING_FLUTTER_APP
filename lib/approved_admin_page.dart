import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedSeatsPage extends StatelessWidget {
  final String currentDate;

  ApprovedSeatsPage({required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Approved Seats',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF681E1E),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(currentDate).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> approvedSeats = [];

          // Loop through each document and filter approved seats
          for (var doc in snapshot.data!.docs) {
            var seatData = doc['seats'] ?? [];
            for (var seat in seatData) {
              if (seat['status'] == 'Approved') {
                // Get the seat number (assuming it's stored as 'seatNumber')
                approvedSeats.add({
                  'seatName': seat['name'], // Assuming 'name' is the seat's name
                  'seatNumber': seat['randomNumber'], // Fetching the seat number
                  
                });
              }
            }
          }

          // If no approved seats found
          if (approvedSeats.isEmpty) {
            return Center(child: Text('No approved seats available.'));
          }

          return ListView.builder(
            itemCount: approvedSeats.length,
            itemBuilder: (context, index) {
              var seat = approvedSeats[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text(
                     
                      'Customer: ${seat['seatName']}'.toUpperCase(),
                       maxLines: 1, 
      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text('Number: ${seat['seatNumber']}'.toUpperCase(),
                     maxLines: 1, 
      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
