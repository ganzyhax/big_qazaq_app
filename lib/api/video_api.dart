import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class FileApi {
  Future<String?> uploadPDF() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      // Use file picker to select a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        final Reference storageReference =
            storage.ref().child('images/${DateTime.now()}.jpg');

        final UploadTask uploadTask = storageReference.putFile(file!);
        await uploadTask.whenComplete(() {});

        final String downloadUrl = await storageReference.getDownloadURL();
        return downloadUrl;
      } else {
        // User canceled the picker
        print('File picking canceledd');
        return null;
      }
    } catch (e) {
      print('Error uploading PDF to Firebase Storage: $e');
      return null;
    }
  }

  Future<dynamic> uploadVideo(
      {required Function(double) onProgress, var file}) async {
    if (file == null) return;
    var videoId = await createVideo('tet');

    final url = Uri.parse('https://ws.api.video/videos/$videoId/source');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization':
          'Bearer UTfzaMxBnTaISZWd60ng1PReroG2bB51TflB3eQawB7', // Replace with your API key
    });

    var fileStream = http.ByteStream(file!.openRead());
    var length = await file!.length();

    var multipartFile = http.MultipartFile(
      'file',
      fileStream,
      length,
      filename: basename(file!.path),
    );

    request.files.add(multipartFile);

    try {
      var streamedResponse = await request.send();

      double totalBytes = streamedResponse.contentLength?.toDouble() ?? 0.0;
      double bytesUploaded = 0;

      streamedResponse.stream.listen(
        (List<int> chunk) {
          bytesUploaded += chunk.length;
          double progress = bytesUploaded / totalBytes;
          onProgress(progress); // Callback to update progress
        },
        onDone: () async {
          var response = await http.Response.fromStream(streamedResponse);
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            log(jsonResponse);
            return jsonResponse;
            // Handle success (e.g., show success message)
          } else {
            print('Upload failed with status ${response.statusCode}');
            // Handle error (e.g., show error message)
          }
        },
        onError: (e) {
          print('Error uploading video: $e');
          return false;
        },
      );
    } catch (e) {
      log(e.toString());
      print('Error uploading video: $e');
      return false;
    }
  }

  Future<dynamic> createVideo(String title) async {
    final url = Uri.parse('https://ws.api.video/videos');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer UTfzaMxBnTaISZWd60ng1PReroG2bB51TflB3eQawB7', // Replace with your API key
    };
    final body = jsonEncode({'title': title});

    try {
      final response = await http.post(url, headers: headers, body: body);
      log(response.body.toString());
      if (response.statusCode == 201) {
        print('Video created successfully');
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse;
        // Handle success (e.g., navigate to next screen)
      } else {
        print('Failed to create video. Status code: ${response.statusCode}');
        // Handle error (e.g., show error message)
      }
    } catch (e) {
      print('Error creating video: $e');
      return false;
      // Handle network error
    }
  }
}
