import 'package:flutter/material.dart';

class GetCryptoCollections extends StatefulWidget {
  const GetCryptoCollections({super.key});

  @override
  State<GetCryptoCollections> createState() => _GetCryptoCollectionsState();
}

class _GetCryptoCollectionsState extends State<GetCryptoCollections> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    // Set item dimensions based on screen width
    final itemWidth = screenWidth * 0.4; // 40% of screen width
    final itemHeight = 70.0;

    return Column(
      children: [
        // Coinbase and Metamask
        _buildCryptoRow(
          context,
          [
            _buildCryptoContainer(
              context,
              'Coinbase',
              'assest/coinbase.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildCryptoContainer(
              context,
              'Metamask',
              'assest/fox.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Trust Wallet and Coinomi
        _buildCryptoRow(
          context,
          [
            _buildCryptoContainer(
              context,
              'Trust Wallet',
              'assest/trust-wallet-token.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildCryptoContainer(
              context,
              'Coinomi',
              'assest/coinomi.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Electrum and Atomic Wallet
        _buildCryptoRow(
          context,
          [
            _buildCryptoContainer(
              context,
              'Electrum',
              'assest/electrum.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildCryptoContainer(
              context,
              'Atomic Wallet',
              'assest/atomic.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Exodus and Keepkey
        _buildCryptoRow(
          context,
          [
            _buildCryptoContainer(
              context,
              'Exodus',
              'assest/exodus.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildCryptoContainer(
              context,
              'Keepkey',
              'assest/keepkey.jpg',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
        // Zengo and Trezo
        _buildCryptoRow(
          context,
          [
            _buildCryptoContainer(
              context,
              'Zengo',
              'assest/zengo.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
            _buildCryptoContainer(
              context,
              'Trezo',
              'assest/trezo.png',
              itemWidth,
              itemHeight,
                  () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCryptoRow(BuildContext context, List<Widget> containers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: containers,
    );
  }

  Widget _buildCryptoContainer(
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
