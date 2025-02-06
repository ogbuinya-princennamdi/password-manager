import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passwordmanager/model/login_response_model.dart';

class APIServices {
  static var client = http.Client();

  static Future<LoginResponseModel> otpLogin(String email) async {
    var url = Uri.http("192.168.43.39:4500", "otpLogin");

    try {
      var response = await client.post(
        url,
        headers: {'Content-type': "application/json"},
        body: jsonEncode({"email": email}),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        return loginResponseModel(response.body);
      } else {
        throw Exception('Failed to login: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during OTP login: $e');
    }
  }
// send message function

  static Future<LoginResponseModel>sendSupport(String email, String supportController) async{

    var url=Uri.http("192.168.43.39:4500","sendSupport");
    try{
      var response = await client.post(
        url,
        headers:  {'Content-Type':"application/json"},
          body: jsonEncode({
            "email": email,
            "support": supportController

          }),
      );
      //checking response status code
      if(response.statusCode==200){
        return loginResponseModel(response.body);
      }else{
        throw Exception('Failed to send message: ${response.reasonPhrase} (${response.statusCode})');
      }

    }catch(e){
      throw Exception('Error during sending message : $e');

    }
  }
  static Future<LoginResponseModel> otpVerify(
      String email, String otpHass, String otpCode) async {
    var url = Uri.http("192.168.43.39:4500", "otpVerify");

    try {
      var response = await client.post(
        url,
        headers: {'Content-type': "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otpCode,
          "hash": otpHass,
        }),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        return loginResponseModel(response.body);
      } else {
        throw Exception('Failed to verify OTP: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during OTP verification: $e');
    }
  }
}
