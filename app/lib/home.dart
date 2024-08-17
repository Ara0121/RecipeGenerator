import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _allIngredients = [];
  List<String> _filteredIngredients = [];
  List<String> _selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    _loadIngredients();
    _controller.addListener(_filterIngredients);
  }

  Future<void> _loadIngredients() async {
    // Load the CSV file from the assets folder
    final String csvData = await rootBundle.loadString('assets/ingredient.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);

    setState(() {
      // Skip the header and extract the first column (ingredient names)
      _allIngredients = csvTable.skip(1).map((row) => row[0].toString()).toList();
    });
  }

  void _filterIngredients() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredIngredients = _allIngredients
          .where((ingredient) => ingredient.toLowerCase().startsWith(query))
          .toList();
    });
  }

  void _addIngredient(String ingredient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add $ingredient'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              setState(() {
                _selectedIngredients.add('$value x $ingredient');
              });
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editIngredient(int index) {
    final ingredient = _selectedIngredients[index]['ingredient'];
    final currentAmount = _selectedIngredients[index]['amount'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $ingredient'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: currentAmount),
            onSubmitted: (value) {
              setState(() {
                _selectedIngredients[index]['amount'] = value;
              });
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeIngredient(int index) {
    setState(() {
      _selectedIngredients.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Search Ingredient',
              border: OutlineInputBorder(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = _filteredIngredients[index];
                return ListTile(
                  title: Text(ingredient),
                  onTap: () => _addIngredient(ingredient),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Selected Ingredients:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = _selectedIngredients[index];
                return ListTile(
                  title: Text('${ingredient['amount']} x ${ingredient['ingredient']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editIngredient(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeIngredient(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}