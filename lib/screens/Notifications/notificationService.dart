import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:passwordmanager/screens/Notifications/viewNotification.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  int loginAttempts = 0;

  Future<void> init(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("@mipmap/litmac");
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
        onDidReceiveNotificationResponse:(NotificationResponse details){
        if(details.payload !=null){
          String userId=details.payload!;
          Navigator.push(context, MaterialPageRoute(builder:(context)=>const ViewNotification()),);
        }

        }
    );
  }

  Future<void> showNotification(String username) async {

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      "login_channel_id",
      "Login Notifications",
      channelDescription: "Notifications for user logins",
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,

    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    try {
      await _flutterLocalNotificationsPlugin.show(
        0,
        "Login Successful",
        "Welcome back $username, you have successfully logged in",
        platformChannelSpecifics,
      );
    }catch (e){
      await _flutterLocalNotificationsPlugin.show(
        0,
        "unable to log in",
        "an error occurred while trying to log in",
        platformChannelSpecifics,
        payload: null,
      );
    }
    loginAttempts++;
  }

  int getLoginAttempts() {
    return loginAttempts;
  }
}
