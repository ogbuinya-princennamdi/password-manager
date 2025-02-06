import 'package:flutter/material.dart';

class GetBankCollections extends StatefulWidget {
  const GetBankCollections({super.key});

  @override
  State<GetBankCollections> createState() => _GetBankCollectionsState();
}

class _GetBankCollectionsState extends State<GetBankCollections> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    // Set item dimensions based on screen width
    final itemWidth = screenWidth * 0.4; // 40% of screen width
    final itemHeight = 70.0;

    return Column(
      children: [
        // ATM and Mobile App
        _buildBankRow(
          context,
          [
            _buildBankContainer(
              context,
              'ATM',
              'assest/atm.jpg',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildBankContainer(
              context,
              'Mobile App',
              'assest/mobile-banking.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Web Banking and Facebook
        _buildBankRow(
          context,
          [
            _buildBankContainer(
              context,
              'Web Banking',
              'assest/smartphone.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildBankContainer(
              context,
              'Facebook',
              'assest/facebook.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Zoho and AOL Mail
        _buildBankRow(
          context,
          [
            _buildBankContainer(
              context,
              'Zoho',
              'assest/zoho.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildBankContainer(
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

  Widget _buildBankRow(BuildContext context, List<Widget> containers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: containers,
    );
  }

  Widget _buildBankContainer(
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              border: Border.all(
                width: 2,
                color: const Color.fromARGB(255, 24, 146, 154),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
