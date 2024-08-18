import 'package:flutter/material.dart';
import 'camera.dart';
import 'recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gemini/flutter_gemini.dart';


// Future<List<String>> getProductList() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('product_list') ?? [];
// }


void main() async{
  Gemini.init(apiKey: 'AIzaSyCIxUA9BOYIgQRnRFdq7IkvOv_TS3lF3NI');
  // List<String> ingredients = await getProductList();
  runApp(MyApp());
}
final gemini = Gemini.instance;

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

class HomeScreen extends StatelessWidget {
  void _removeIngredient(String ingredient, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ingredients = prefs.getStringList('product_list') ?? [];
    ingredients.remove(ingredient);
    await prefs.setStringList('product_list', ingredients);
    // Refresh the UI by rebuilding the widget
    (context as Element).markNeedsBuild();
  }

  Future<List<String>> _getProductList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('product_list') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getProductList(), // Retrieve the ingredients list
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No ingredients found.'));
        } else {
          List<String> ingredients = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Recipes',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Text('Added Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: ingredients.map((ingredient) {
                      return Chip(
                        label: Text(ingredient),
                        backgroundColor: Colors.blue,
                        labelStyle: TextStyle(color: Colors.white),
                        deleteIcon: Icon(Icons.clear, color: Colors.white),
                        onDeleted: () => _removeIngredient(ingredient, context),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
