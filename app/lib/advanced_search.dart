import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class AdvancedSearch extends StatefulWidget {
  @override
  _AdvancedSearchState createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  String? selectedCategory;
  String? selectedCuisine;
  bool willingToShop = false;
  TextEditingController excludeController = TextEditingController();

  List<String> categories = [];
  List<String> cuisines = [];

  @override
  void initState() {
    super.initState();
    loadCSVData();
  }

  Future<void> loadCSVData() async {
    final dietData = await rootBundle.loadString('assets/diet.csv');
    final cuisineData = await rootBundle.loadString('assets/cuisine.csv');

    setState(() {
      categories = CsvToListConverter().convert(dietData).map((e) => e[0].toString()).toList();
      cuisines = CsvToListConverter().convert(cuisineData).map((e) => e[0].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Category'),
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Cuisine'),
              value: selectedCuisine,
              onChanged: (value) {
                setState(() {
                  selectedCuisine = value;
                });
              },
              items: cuisines.map((String cuisine) {
                return DropdownMenuItem<String>(
                  value: cuisine,
                  child: Text(cuisine),
                );
              }).toList(),
            ),
            CheckboxListTile(
              title: Text('Willing to go shopping'),
              value: willingToShop,
              onChanged: (value) {
                setState(() {
                  willingToShop = value!;
                });
              },
            ),
            TextFormField(
              controller: excludeController,
              decoration: InputDecoration(labelText: 'Food to exclude'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the apply action
                    Navigator.pop(context);
                  },
                  child: Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage in your main widget or wherever you handle the sorting button:
void showAdvancedSearchDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AdvancedSearch();
    },
  );
}
