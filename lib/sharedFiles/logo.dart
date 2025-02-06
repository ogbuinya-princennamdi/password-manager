import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
// Text('From',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
//   color: Color.fromARGB(255, 24, 146, 154), )
//   , textAlign: TextAlign.start,),
        SizedBox(height: 2,),
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Color.fromARGB(255, 24, 146, 154), // Border color
                    width: 4, // Border width
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50), // Clip the image to match the border radius
                  child: Image.asset(
                    'assest/litmac.jpeg', // Ensure the path is correct
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),
              ),
              // Text('Litmac',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        Text(
          'Safety in Privacy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
