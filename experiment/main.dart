import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Flask Integration'),
        ),
        body: Center(
          child: PythonRunner(),
        ),
      ),
    );
  }
}

class PythonRunner extends StatefulWidget {
  @override
  _PythonRunnerState createState() => _PythonRunnerState();
}

class _PythonRunnerState extends State<PythonRunner> {
  String _message = "Waiting...";

  @override
  void initState() {
    super.initState();
    _fetchMessage();
  }

  Future<void> _fetchMessage() async {
    final response = await http.get(Uri.parse('http://localhost:5000/hello'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _message = data['message'];
      });
    } else {
      setState(() {
        _message = "Error: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_message);
  }
}
