import 'package:flutter/material.dart';
import 'package:passwordmanager/screens/home/settings/SecurityTip/Tips.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
class Tutorialandguild extends StatefulWidget {
  const Tutorialandguild({super.key});

  @override
  State<Tutorialandguild> createState() => _TutorialandguildState();
}

class _TutorialandguildState extends State<Tutorialandguild> {
  bool _isTips = false;
  Color _profileSettingsColor = Colors.grey.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, transitionEffect(page: Tips()));
                  setState(() {
                    _isTips = !_isTips;
                    _profileSettingsColor = _isTips
                        ? const Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)  // Active color for Profile Settings
                        : Colors.grey.withOpacity(0.5);
                  });
                },
                icon: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.tips_and_updates,
                        size: 40,
                        color:_isTips? _profileSettingsColor :Color.fromARGB(255, 24, 146, 154),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Tips',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isTips ?_profileSettingsColor: null,
                            ),
                          ),
                          Text(
                            ' Security informations',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 19,
                              color: _isTips ?_profileSettingsColor: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        }

    );
  }
}
