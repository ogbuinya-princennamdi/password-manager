import 'dart:math';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class OtpGenerator {
  String? _otp; // Store OTP temporarily

  Future<void> sendEmailOtp(String email, String otp) async {
    final Email sendEmail = Email(
      body: '$otp is your OTP for password manager.',
      subject: 'Your OTP Code',
      recipients: [email],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(sendEmail);
      print('Email sent to $email');
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  Future<void> sendOTP() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = "support@litmaclimited.com";
      if (email != null) {
        _otp = (100000 + Random().nextInt(900000)).toString(); // Store OTP
        await sendEmailOtp(email, _otp!);
        print('OTP sent: $_otp');
      } else {
        print('Email not found for the current user.');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  Future<bool> verifyOtp(String enteredOtp) async {
    if (enteredOtp == _otp) {
      print('OTP verified successfully.');
      return true;
    } else {
      print('Invalid OTP.');
      return false;
    }
  }
}
