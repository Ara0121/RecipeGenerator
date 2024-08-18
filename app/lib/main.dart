import 'package:flutter/material.dart';
import 'camera.dart';
import 'recipe.dart';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

List<String> allIngredients = [];
List<String> selectedIngredients = [];
// SharedPreferences prefs;
final gemini = Gemini.instance;
// final SharedPreferences prefs = await SharedPreferences.getInstance();

void main() {
  Gemini.init(apiKey: 'AIzaSyCIxUA9BOYIgQRnRFdq7IkvOv_TS3lF3NI');
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
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ScanScreen(),
    RecipesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Recipes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  List<String> selectedIngredients = [];
  List<String> allIngredients = [
    // Add your ingredients here
    'adzuki beans',
    'aioli',
    'allspice',
    'almond oil',
    'almonds',
    'amaranth',
    'anchovies',
    'anise',
    'apple',
    'asian sesame dressing',
    'asparagus',
    'avocado',
    'avocado oil',
    'bacon',
    'baking powder',
    'baking soda',
    'balsamic dressing',
    'balsamic glaze',
    'balsamic glaze dressing',
    'banana',
    'barbecue sauce',
    'barley',
    'basil',
    'bay leaves',
    'beef',
    'beetroot',
    'bell pepper',
    'bison',
    'black beans',
    'black pepper',
    'black pepper powder',
    'black-eyed peas',
    'blue cheese dressing',
    'blueberry',
    'brazil nuts',
    'broad beans',
    'broccoli',
    'buckwheat',
    'buffalo',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              // Show the top suggestion as the first result
              return allIngredients.where((String ingredient) {
                return ingredient
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              }).take(1); // Take only the top suggestion
            },
            onSelected: (String selected) {
              setState(() {
                if (!selectedIngredients.contains(selected)) {
                  selectedIngredients.add(selected);
                }
              });
            },
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Search Ingredients',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  // Automatically select the top suggestion when typing
                  final topSuggestion = allIngredients.firstWhere(
                      (ingredient) => ingredient.toLowerCase().contains(text.toLowerCase()),
                      orElse: () => '');
                  if (topSuggestion.isNotEmpty) {
                    controller.text = topSuggestion;
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: topSuggestion.length),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

