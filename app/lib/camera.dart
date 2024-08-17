import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> scanImage(File imageFile) async {  // Added this function to handle the API call
  final uri = Uri.parse('http://localhost:5000/scan');  // Updated to point to Flask API
  final request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
  
  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  
  final responseJson = jsonDecode(responseBody);
  
  if (response.statusCode == 200) {
    return responseJson['result'];
  } else {
    return 'Error: ${responseJson['error']}';
  }
}

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras![0], ResolutionPreset.high);
    await _controller?.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      return;
    }
    if (_controller!.value.isTakingPicture) {
      return;
    }

    try {
      XFile picture = await _controller!.takePicture();
      final File imageFile = File(picture.path);  // Added this line to convert XFile to File

      final result = await scanImage(imageFile);  // Added this line to send image to API
      print('Scan result: $result');  // Added this line to print the result

      setState(() {
        _imageFile = picture;
      });

      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/Pictures/flutter_scan';
      await Directory(dirPath).create(recursive: true);
      final String filePath = join(
        dirPath,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await picture.saveTo(filePath);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Camera Preview
          CameraPreview(_controller!),
          
          // Positioned buttons at the bottom center
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: Icon(Icons.photo),
                  label: Text('Gallery'),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _takePicture,
                  icon: Icon(Icons.camera),
                  label: Text('Take Picture'),
                ),
              ],
            ),
          ),

          if (_imageFile != null)
            Positioned(
              top: 20.0,
              right: 20.0,
              child: Image.file(
                File(_imageFile!.path),
                width: 100,
                height: 100,
              ),
            ),
        ],
      ),
    );
  }
}
