import "dart:async";
import "dart:io";
import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";
class imageUpload extends StatefulWidget {
  const imageUpload({super.key});

  @override
  State<imageUpload> createState() => _imageUploadState();
}

class _imageUploadState extends State<imageUpload> {
  File? _imageFile;
  final picker = ImagePicker();

  Future <void> imagePicker() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
