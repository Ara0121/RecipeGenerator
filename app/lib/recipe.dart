import 'package:flutter/material.dart';

class RecipesScreen extends StatelessWidget {
  // Replace this with your actual recipe data
  final List<Map<String, String>> recipes = [
    {
      'name': 'Spaghetti Bolognese',
      'ingredients': 'Pasta, Tomato Sauce, Ground Beef, Garlic, Onion',
      'instructions': '1. Cook pasta...\n2. Prepare sauce...',
    },
    {
      'name': 'Chicken Curry',
      'ingredients': 'Chicken, Curry Paste, Coconut Milk, Vegetables',
      'instructions': '1. Cook chicken...\n2. Add curry paste...',
    },
    {
      'name': 'Beef Stroganoff',
      'ingredients': 'Beef, Mushrooms, Sour Cream, Onion, Garlic',
      'instructions': '1. Cook beef...\n2. Add mushrooms...',
    },
    {
      'name': 'Vegetable Stir Fry',
      'ingredients': 'Vegetables, Soy Sauce, Garlic, Ginger',
      'instructions': '1. Stir fry vegetables...\n2. Add soy sauce...',
    },
    {
      'name': 'Tacos',
      'ingredients': 'Tortillas, Ground Beef, Lettuce, Cheese, Salsa',
      'instructions': '1. Cook beef...\n2. Prepare toppings...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index]['name']!),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(
                    recipe: recipes[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, String> recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe['name']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(recipe['ingredients']!),
            SizedBox(height: 16),
            Text('Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(recipe['instructions']!),
          ],
        ),
      ),
    );
  }
}