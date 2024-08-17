import 'package:flutter/material.dart';
import 'camera.dart';
import 'recipe.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


void main() {
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
  TextEditingController searchController = TextEditingController();
  List<String> ingredients = [];
  List<String> filteredIngredients = [];
  List<String> addedIngredients = [];

  @override
  void initState() {
    super.initState();
    loadIngredients();
    searchController.addListener(_filterIngredients);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadIngredients() async {
    final String response = await rootBundle.loadString('assets/ingredients.csv');
    final List<String> data = const LineSplitter().convert(response);
    setState(() {
      ingredients = data;
      filteredIngredients = ingredients;
    });
  }

  void _filterIngredients() {
    setState(() {
      filteredIngredients = ingredients
          .where((ingredient) => ingredient
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _addIngredient(String ingredient) {
    setState(() {
      addedIngredients.add(ingredient);
      searchController.clear();
      filteredIngredients = ingredients;
    });
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      addedIngredients.remove(ingredient);
    });
  }

  void _resetIngredients() {
    setState(() {
      addedIngredients.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search Ingredients',
              border: OutlineInputBorder(),
            ),
          ),
          if (searchController.text.isNotEmpty && filteredIngredients.isNotEmpty)
            Container(
              height: 150,
              child: ListView.builder(
                itemCount: filteredIngredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredIngredients[index]),
                    onTap: () => _addIngredient(filteredIngredients[index]),
                  );
                },
              ),
            ),
          SizedBox(height: 20),
          if (addedIngredients.isNotEmpty) ...[
            Text('Added Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: addedIngredients.map((ingredient) {
                return Chip(
                  label: Text(ingredient),
                  deleteIcon: Icon(Icons.clear),
                  onDeleted: () => _removeIngredient(ingredient),
                );
              }).toList(),
            ),
          ],
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _resetIngredients,
                child: Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  // For now, do nothing when "Search" is pressed
                },
                child: Text('Search'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
