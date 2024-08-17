import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

//edited
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
    final String response = await rootBundle.loadString('assets/ingredient.csv');
    final List<String> data = const LineSplitter().convert(response);
    setState(() {
      ingredients = data;
    });
  }

  void _filterIngredients() {
    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        filteredIngredients = ingredients
            .where((ingredient) => ingredient.toLowerCase().contains(query))
            .toList();
      });
    } else {
      setState(() {
        filteredIngredients = [];
      });
    }
  }

  void _addIngredient(String ingredient) {
    if (!addedIngredients.contains(ingredient)) {
      setState(() {
        addedIngredients.add(ingredient);
      });
    }
    searchController.clear();
    setState(() {
      filteredIngredients = [];
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search Ingredients',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          if (filteredIngredients.isNotEmpty)
            Expanded(
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
          Text('Added Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: addedIngredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(addedIngredients[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => _removeIngredient(addedIngredients[index]),
                  ),
                );
              },
            ),
          ),
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
