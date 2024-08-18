import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:csv/csv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart' show rootBundle;



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
    if (image != null){
      scanImage(image);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Scanned Ingredients'),
            content: Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                  ),
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

final gemini = Gemini.instance;

void scanImage(XFile? imageFile) async {
   final csvData = await rootBundle.loadString('assets/ingredient.csv');
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
  List<String> ingredients = csvTable.skip(1).map((row) => row[0].toString()).toList();
  String ingredientsList = ingredients.join(', ');

  final prompt = """
  List product names on the receipt from products listed in this list. If product is not in the list, skip it.

  $ingredientsList

  Only return the type of product, remove the description

  Example output:
  apple
  banana
  salt
  """;

  if (imageFile != null) {
    try {
      final file = File(imageFile.path);
      final imageBytes = await file.readAsBytes();  // Read image bytes asynchronously

      // Update the API call to use the supported model
      final result = await gemini.textAndImage(
        text: prompt,  // Query text
        images: [imageBytes],           // Pass the image bytes
      );

      print(result?.content?.parts?.last.text ?? 'No result found');
    } catch (e) {
      print('Error during image scan: $e');
    }
  } else {
    print('No image selected.');
  }
}