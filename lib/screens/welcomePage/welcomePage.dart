import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _loading = false;
  double _textContainerHeight = 0.0;

  void _startLoading() {
    setState(() {
      _loading = true;
    });

    // Simulate a network request or a long task
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate container height when dependencies change
    _calculateTextContainerHeight();
  }

  void _calculateTextContainerHeight() {
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 23,
      fontFamily: 'Poppins-Regular',
      fontWeight: FontWeight.normal,
      wordSpacing: 3,
    );

    final textSpan = TextSpan(
      text:  'Hi,'
          'Instead of juggling multiple with passwords, you only need '
          'to remember one master password to access your entire vault.',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: null,
      textAlign: TextAlign.justify,
      textDirection: TextDirection.ltr,
    );

    // Measure the text height based on the width of the container
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width * 0.55);

    // Update container height based on the text height plus padding
    setState(() {
      _textContainerHeight = textPainter.size.height + 32; // Add padding for visual comfort
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assest/Metaverse.jpg', // Ensure the path is correct
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50), // Add space at the top
                // Center image with responsive width
                Center(
                  child: Image.asset(
                    'assest/signincenteredImg.png', // Ensure the path is correct
                    width: screenSize.width * 0.8, // Responsive width
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: screenSize.width * 0.8, // Responsive width
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 24, 146, 154),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(255, 185, 231, 225),
                    ),
                  ),
                  height: _textContainerHeight, // Responsive height
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        ' Hi, '
                            'Instead of juggling with multiple passwords, you only need '
                            'to remember one master password to access your entire vault.',
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.normal,
                          wordSpacing: 3,
                        ),
                        textAlign: TextAlign.justify,
                        speed: const Duration(milliseconds: 50), // Adjust typing speed
                      ),
                    ],
                    totalRepeatCount: 1, // Set to `1` to type out text once
                  ),
                ),
                const SizedBox(height: 80),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: screenSize.width * 0.8, // Responsive width
                    child: ElevatedButton(
                      onPressed: () {
                        _startLoading(); // Trigger loading state
                        Navigator.pushNamed(context, 'authenticate');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 24, 146, 154),
                        minimumSize: const Size(double.infinity, 50), // Full width button
                      ),
                      child: const Text(
                        'Get started',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 200), // Space below the button
              ],
            ),
          ),
          if (_loading) // Show loading indicator if _loading is true
            const Center(
              child: loading(),
            ),
        ],
      ),
    );
  }
}
