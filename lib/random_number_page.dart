import 'package:flutter/material.dart';

class RandomNumberPage extends StatefulWidget{

   final String name;
  final String randomNumber;
  final String date;
  final String adminNumber;

  const RandomNumberPage({
    required this.name,
    required this.randomNumber,
    required this.date,
    required this.adminNumber,
    Key? key,
  }) : super(key: key);


  @override
  State<RandomNumberPage> createState() => _RandomNumberPageState();
}

class _RandomNumberPageState extends State<RandomNumberPage> {
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.height;
    var screenheight = MediaQuery.of(context).size.width;
    
    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body:Center(child: Column(children: [

        SizedBox(height:screenheight*0.45),

        Container(
          child:Text('Your booking request been sent !!!',style:TextStyle(fontSize: 16,color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold,)),
        ),

        SizedBox(height: screenheight*0.3,),

        Padding(padding:EdgeInsets.symmetric(horizontal: 20),child:Container(
          height: screenheight*0.7,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 224, 158, 88),
            ) ,
            child:Column(
              children: [
                SizedBox(height: screenheight*0.05,),
                

                Container(
                  child:
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                    Text('Booking Details',style:TextStyle(fontSize: 16,color:const Color.fromARGB(255, 127, 120, 120),fontWeight: FontWeight.bold)),
                    SizedBox(width: screenwidth*0.01),
                   // Icon(Icons.cut,color: Colors.white,size: 20,),
              ]),),
                SizedBox(height: screenheight*0.08,),
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text('   Your Name           :   ${widget.name}',overflow: TextOverflow.ellipsis,maxLines: 1,
                  style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
                ),
                SizedBox(height: screenheight*0.05,),
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text('   Booked Date        :   ${widget.date}',overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
                ),
                SizedBox(height: screenheight*0.05,),
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text('   Booked Number  :   ${widget.randomNumber}',overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
                ),
                 SizedBox(height: screenheight*0.05,),
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text('   Admin Number    :   ${widget.adminNumber}',overflow: TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color:const Color.fromARGB(255, 74, 25, 7),fontWeight: FontWeight.bold))
                ),

              ],
            )
            
               ),
        ),
        SizedBox(height: screenheight*0.3,),

       GestureDetector(
        onTap:(){},
        child:Padding(padding:EdgeInsets.symmetric(horizontal: 13),child:Container(
          
          height: screenheight*0.15,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 74, 25, 7),
            borderRadius: BorderRadius.circular(40)
          ),
          child:Center(child: Text('Wait for your conformation',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),))
        )
       )


      )],),)
    );
  }
}