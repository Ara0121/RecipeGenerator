import 'package:flutter/material.dart';
import 'camera.dart';
import 'recipe.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

List<String> allIngredients = [];
List<String> selectedIngredients = [];
// SharedPreferences prefs;
final gemini = Gemini.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized before async operations
  Gemini.init(apiKey: 'AIzaSyCIxUA9BOYIgQRnRFdq7IkvOv_TS3lF3NI');
  // await initSharedPreferences();
  await loadIngredients();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chow Down',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _filteredIngredients = [];
  String _selectedIngredient = '';

  @override
  void initState() {
    super.initState();
  }

  void _filterIngredients(String query) {
    setState(() {
      _filteredIngredients.clear();
      if (query.isNotEmpty) {
        _filteredIngredients.addAll(allIngredients.where((ingredient) =>
            ingredient.toLowerCase().contains(query.toLowerCase())));
        if (_filteredIngredients.length > 5) {
          _filteredIngredients.removeRange(5, _filteredIngredients.length);
        }
      }
    });
  }

  void _addIngredient(String ingredient) {
    setState(() {
      if (!selectedIngredients.contains(ingredient)) {
        selectedIngredients.add(ingredient);
      }
      _controller.clear();
      _filteredIngredients.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Search Ingredients',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => _filterIngredients(text),
          ),
          if (_filteredIngredients.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 8.0),
              child: DropdownButton<String>(
                value: _selectedIngredient,
                hint: Text('Select an ingredient'),
                items: _filteredIngredients.map((ingredient) {
                  return DropdownMenuItem<String>(
                    value: ingredient,
                    child: Text(ingredient),
                  );
                }).toList(),
                onChanged: (value) {
                  _addIngredient(value as String);
                },
              ),
            ),
          ],
          SizedBox(height: 16.0),
          // Text(
          //   'Selected Ingredients:',
          //   style: Theme.of(context).textTheme.headline6,
          // ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: selectedIngredients.map((ingredient) {
              return Chip(
                label: Text(ingredient),
                onDeleted: () {
                  setState(() {
                    selectedIngredients.remove(ingredient);
                  });
                },
              );
            }).toList(),
          ),
          // Additional home page content can go here
        ],
      ),
    );
  }
}

Future<void> loadIngredients() async {
  final String response = await rootBundle.loadString('assets/ingredient.csv');
  final List<String> data = const LineSplitter().convert(response);
  // setState(() {
  allIngredients = data;
  // });
}

// Future<void> initSharedPreferences() async {
//   prefs = await SharedPreferences.getInstance();
// }
