import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GlobalFunctions {
  Future<String> uploadImageToImgBB(BuildContext context) async {
    final String apiKey =
        'd0a7267fe08131bce8959f35e00a3647'; // Replace with your ImgBB API key
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final Uri apiUrl =
          Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');
      // Create multipart request for image upload
      var request = http.MultipartRequest('POST', apiUrl)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      // Send request and get response
      var response = await request.send();
      if (response.statusCode == 200) {
        final String responseData = await response.stream.bytesToString();
        final Map<String, dynamic> decodedResponse = json.decode(responseData);
        if (decodedResponse['data'] != null &&
            decodedResponse['data']['url'] != null) {
          return decodedResponse['data']['url'];
        } else {
          print('Error');
          return 'null';
        }
      } else {
        print(
            "Failed to upload image to ImgBB. Status code: ${response.statusCode}");
        return 'null';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
      return 'null';
    }
  }
}
