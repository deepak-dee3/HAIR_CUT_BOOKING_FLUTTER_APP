import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SignInUpPage extends StatelessWidget {
  const SignInUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none, // Allows widgets to overflow the Stack
          children: [
            // Background Container
            Container(
              height: screenheight*0.4,
              decoration: const BoxDecoration(
                color: Color(0xFF681E1E), // Dark Red
                borderRadius: BorderRadius.only(
                   //bottomLeft: Radius.circular(300),
                  bottomRight: Radius.circular(300),
                ),
              ),
            ),

            // Positioned Sign In Container
            Positioned(
              top: 220, // Adjust the position to overlap the background
              left: 30,
              right: 30,
              child: Container(
                height: screenheight*0.55,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenheight*0.05,),
                    // Sign In Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 40,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD3C6), // Light Red/Pink
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Color(0xFF681E1E), // Dark Red
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                     SizedBox(height:  screenheight*0.053),

                    // Email Field
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.03,),

                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.lock_outline,shadows: [
                          Shadow(
                            color: Color(0xFF681E1E),
                            //blurRadius: 3,
                            
                          )
                        ],),
                       
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.053,),

                    // Log In Button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF681E1E), // Dark Red
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'ENTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.05,),
                  ],
                ),
              ),
              
            ),
           // Text('dat',style: TextStyle(color: Colors.red),)

            // //Additional Spacing for Scrollable Effect
            // Positioned(
            //   //left: 180,
            //   top: 750, // Add enough space after the Sign In container
            //   child: Text('Already hav an account ?')
            // ),

            GestureDetector(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LogInUpPage()));
                Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        curve: Curves.linear,
        child: LogInUpPage(),
        inheritTheme: true,
        ctx: context),
);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 750),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Already have an account ? ',
                    style: TextStyle(
                       color: Color(0xFF681E1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
           


          ],
        ),
        
        
      ),
    );
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
///





class LogInUpPage extends StatelessWidget {
  const LogInUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none, // Allows widgets to overflow the Stack
          children: [
            // Background Container
            Container(
              height: screenheight*0.4,
              decoration: const BoxDecoration(
                color: Color(0xFF681E1E), // Dark Red
                borderRadius: BorderRadius.only(
                   bottomLeft: Radius.circular(300),
                 // bottomRight: Radius.circular(300),
                ),
              ),
            ),

            // Positioned Sign In Container
            Positioned(
              top: 220, // Adjust the position to overlap the background
              left: 30,
              right: 30,
              child: Container(
                height: screenheight*0.55,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenheight*0.05,),
                    // Sign In Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 40,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD3C6), // Light Red/Pink
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          color: Color(0xFF681E1E), // Dark Red
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.053,),

                    // Email Field
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.03,),

                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.053,),


                    // Log In Button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF681E1E), // Dark Red
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'ENTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(height: screenheight*0.05,),
                  ],
                ),
              ),
              
            ),
           // Text('dat',style: TextStyle(color: Colors.red),)

            // //Additional Spacing for Scrollable Effect
            // Positioned(
            //   //left: 180,
            //   top: 750, // Add enough space after the Sign In container
            //   child: Text('Already hav an account ?')
            // ),

            GestureDetector(
              
               onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInUpPage()));
               Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        curve: Curves.linear,
        child: SignInUpPage(),
        inheritTheme: true,
        ctx: context),
);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 750),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create a new account ? ',
                    style: TextStyle(
                      color: Color(0xFF681E1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
           


          ],
        ),
        
        
      ),
    );
  }
}
