
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class MainPage extends StatelessWidget {
  // Function to open Google Pay app
  void openGooglePay() async {
    final Uri googlePayUri = Uri.parse('https://gpay.app.goo.gl/'); // Google Pay link

    if (await canLaunch(googlePayUri.toString())) {
      await launch(googlePayUri.toString());
    } else {
      throw 'Could not open Google Pay';
    }
  }

  void openPhonePe() async {
    final Uri phonePeUri = Uri.parse('https://phonepe.com/app'); // PhonePe link

    if (await canLaunch(phonePeUri.toString())) {
      await launch(phonePeUri.toString());
    } else {
      throw 'Could not open PhonePe';
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Google Pay'),
      ),
      body: Center(
        child:Column(children:[

          SizedBox(height: 80,),
           ElevatedButton(
          onPressed: openGooglePay, // Opens Google Pay app
          child: Text('Open Google Pay'),
        ),
        SizedBox(height: 20,),
        ElevatedButton(
          onPressed: openPhonePe, // Opens Google Pay app
          child: Text('Open Phone Pe'),
        ),
        ])
      ),
    );
  }
}

// void openPhonePe() async {
//     final Uri phonePeUri = Uri.parse('https://phonepe.com/app'); // PhonePe link

//     if (await canLaunch(phonePeUri.toString())) {
//       await launch(phonePeUri.toString());
//     } else {
//       throw 'Could not open PhonePe';
//     }
//   }


//  void openKVBApp() async {
//     final Uri kvbUri = Uri.parse('https://kvb.com/app'); // Replace with actual KVB app URI or deep link

//     if (await canLaunch(kvbUri.toString())) {
//       await launch(kvbUri.toString());
//     } else {
//       throw 'Could not open KVB App';
//     }
//   }