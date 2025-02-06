import 'package:flutter/material.dart';

class GetSocialMediaCollections extends StatefulWidget {
  const GetSocialMediaCollections({super.key});

  @override
  State<GetSocialMediaCollections> createState() => _GetSocialMediaCollectionsState();
}

class _GetSocialMediaCollectionsState extends State<GetSocialMediaCollections> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    // Set item dimensions based on screen width
    final itemWidth = screenWidth * 0.4; // 40% of screen width
    final itemHeight = 70.0;

    return Column(
      children: [
        // TikTok and Instagram
        _buildSocialMediaRow(
          context,
          [
            _buildSocialMediaContainer(
              context,
              'TikTok',
              'assest/tik-tok.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildSocialMediaContainer(
              context,
              'Instagram',
              'assest/instagram.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Twitter and Binance
        _buildSocialMediaRow(
          context,
          [
            _buildSocialMediaContainer(
              context,
              'Twitter',
              'assest/twitter.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildSocialMediaContainer(
              context,
              'Binance',
              'assest/binance.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Zoho and AOL Mail
        _buildSocialMediaRow(
          context,
          [
            _buildSocialMediaContainer(
              context,
              'Zoho',
              'assest/zoho.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildSocialMediaContainer(
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

  Widget _buildSocialMediaRow(BuildContext context, List<Widget> containers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: containers,
    );
  }

  Widget _buildSocialMediaContainer(
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
