import 'dart:convert';

LoginResponseModel loginResponseModel(String str) => LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  final String message;
  final String? data;

  LoginResponseModel({
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('message')) {
      throw FormatException('Missing message field in JSON');
    }

    return LoginResponseModel(
      message: json['message'] as String,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'LoginResponseModel(message: $message, data: $data)';
  }
}
