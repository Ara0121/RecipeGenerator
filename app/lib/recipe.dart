import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<dynamic> recipes = [];
  List<dynamic> filteredRecipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRecipes();
    searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRecipes() async {
    final String response = await rootBundle.loadString('assets/recipes.json');
    final data = await json.decode(response) as List;
    setState(() {
      recipes = data;
      filteredRecipes = recipes;
    });
  }

  void _filterRecipes() {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) => recipe['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Recipes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: filteredRecipes[index]['image'] != null
                      ? Image.network(
                          filteredRecipes[index]['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : null,
                  title: Text(filteredRecipes[index]['name']!),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipe: filteredRecipes[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final dynamic recipe;

  RecipeDetailScreen({required this.recipe});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe['name'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe['image'] != null)
              Image.network(recipe['image']),
            SizedBox(height: 16),
            Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...recipe['ingredient'].map<Widget>((ing) {
              return Text('${ing['quantity']} ${ing['name']}');
            }).toList(),
            SizedBox(height: 16),
            Text('Nutrition', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...recipe['nutrition'].map<Widget>((nutr) {
              return Text('${nutr['name']}: ${nutr['quantity']}');
            }).toList(),
            SizedBox(height: 16),
            Text('Calories: ${recipe['calories']}'),
            Text('Servings: ${recipe['servings']}'),
            Text('Duration: ${recipe['duration']} minutes'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final url = recipe['url'];
                if (url != null && url.isNotEmpty) {
                  _launchURL(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No URL provided for this recipe')),
                  );
                }
              },
              child: Text('View Recipe Online'),
            ),
          ],
        ),
      ),
    );
  }
}
