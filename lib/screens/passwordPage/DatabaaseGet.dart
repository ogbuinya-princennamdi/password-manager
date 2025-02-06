import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/screens/home/firestoreCollections/gmailFirestoreCollections.dart';
import '../../sharedFiles/transitionEffect.dart';

class getEmailCollections extends StatefulWidget {
  const getEmailCollections({super.key});

  @override
  State<getEmailCollections> createState() => _getEmailCollectionsState();
}

class _getEmailCollectionsState extends State<getEmailCollections> {
  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Set item width and height proportionally
    final itemWidth = screenWidth * 0.4; // 40% of screen width
    final itemHeight = 70.0;

    return Column(
      children: [
        // Gmail and Outlook
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildEmailContainer(
              context,
              'Gmail',
              'assest/gmail.png',
              itemWidth,
              itemHeight,
                  () {
                Navigator.push(context, transitionEffect(page: gmailFirestoreCollection()));
              },
            ),
            buildEmailContainer(
              context,
              'Outlook',
              'assest/outlook.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Yahoo and Proton
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildEmailContainer(
              context,
              'Yahoo',
              'assest/yahoo.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            buildEmailContainer(
              context,
              'Proton',
              'assest/protomail.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Zoho and AOL
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildEmailContainer(
              context,
              'Zoho',
              'assest/zoho.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            buildEmailContainer(
              context,
              'AOL Mail',
              'assest/aol.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget buildEmailContainer(
      BuildContext context,
      String title,
      String imagePath,
      double width,
      double height,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.white,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            alignment: AlignmentDirectional.center,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              border: Border.all(width: 2, color: Color.fromARGB(255, 24, 146, 154)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    imagePath,
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
