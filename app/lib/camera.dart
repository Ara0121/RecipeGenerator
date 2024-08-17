import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

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
    scanImage();
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
      print(filePath); // Debugging
      await picture.saveTo(filePath);
      _showPopUp(context, _imageFile); // Pass context
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      _showPopUp(context, _imageFile); // Pass context
    }
  }

  void _showPopUp(BuildContext context, XFile? image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned Ingredients'),
          content: image != null
              ? Image.file(
                  File(image.path),
                  width: 100,
                  height: 100,
                )
              : Text('No image selected'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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
          CameraPreview(_controller!),
          
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
        ],
      ),
    );
  }
}

final gemini = GoogleGemini(
  apiKey: "AIzaSyCIxUA9BOYIgQRnRFdq7IkvOv_TS3lF3NI",
);

String scanImage(XFile imageFile = null) {
  // File image = File(imageFile);
  File image = File('RecipeGenerator/app/assets/receipt1.jpg')
  String query = "What is this picture?";

  gemini.generateFromTextAndImages(
    query: query,
    image: image
  )
  .then((value) => print(value.text))
  .catchError((e) => print(e));
}