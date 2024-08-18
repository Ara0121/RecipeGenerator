// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:csv/csv.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AdvancedSearch extends StatefulWidget {
//   @override
//   _AdvancedSearchState createState() => _AdvancedSearchState();
// }

// class _AdvancedSearchState extends State<AdvancedSearch> {
//   String? selectedCategory;
//   String? selectedCuisine;
//   bool willingToShop = false;
//   TextEditingController excludeController = TextEditingController();

//   List<String> categories = [];
//   List<String> cuisines = [];
//   List<String> ingredients = [];
//   List<Map<String, dynamic>> recipes = [];

//   @override
//   void initState() {
//     super.initState();
//     loadCSVData();
//     final recipeData = await rootBundle.loadString('assets/recipes.json'); //
//     final recipes = await json.decode(recipeData) as List; //
//     print(recipes); // TODO
//   }

//   Future<void> loadCSVData() async {
//     final dietData = await rootBundle.loadString('assets/diet.csv');
//     final cuisineData = await rootBundle.loadString('assets/cuisine.csv');
//     final IngredientData = await rootBundle.loadString('assets/ingredients.csv');

//     setState(() {
//       categories = CsvToListConverter().convert(dietData).map((e) => e[0].toString()).toList();
//       cuisines = CsvToListConverter().convert(cuisineData).map((e) => e[0].toString()).toList();
//       ingredients = CsvToListConverter().convert(IngredientData).map((e) => e[0].toString()).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: 'Category'),
//               value: selectedCategory,
//               onChanged: (value) {
//                 setState(() {
//                   selectedCategory = value;
//                 });
//               },
//               items: categories.map((String category) {
//                 return DropdownMenuItem<String>(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//             ),
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: 'Cuisine'),
//               value: selectedCuisine,
//               onChanged: (value) {
//                 setState(() {
//                   selectedCuisine = value;
//                 });
//               },
//               items: cuisines.map((String cuisine) {
//                 return DropdownMenuItem<String>(
//                   value: cuisine,
//                   child: Text(cuisine),
//                 );
//               }).toList(),
//             ),
//             CheckboxListTile(
//               title: Text('Willing to go shopping'),
//               value: willingToShop,
//               onChanged: (value) {
//                 setState(() {
//                   willingToShop = value!;
//                 });
//               },
//             ),
//             // TextFormField(
//             //   controller: excludeController,
//             //   decoration: InputDecoration(labelText: 'Food to exclude'),
//             // ),
//             // SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle the apply action
//                     Navigator.pop(context);
//                   },
//                   child: Text('Apply'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Example usage in your main widget or wherever you handle the sorting button:
// void showAdvancedSearchDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AdvancedSearch();
//     },
//   );
// }

// // List<Map<String, dynamic>> filterRecipe(
// //   List<String> search_ingredient = null, 
// //   String search_category = null, 
// //   String search_cuisine = null, 
// //   bool partial_match
// // ) {
// //   List<Map<String, dynamic>> filteredRecipes = [];

// //   for (var recipe in recipes) {
// //     // Count ingredients
// //     bool ingredientsMatch = true;
// //     if (search_ingredient) {
// //       int ingredient_counter = 0;
// //       for (var ing in recipe['ingredient']) {
// //         if (ingredients.contains(ing['name'])) {
// //           ingredient_counter++;
// //         }
// //       }

// //       ingredientsMatch = (partialMatch && ingredientCounter >= recipe['ingredient'].length / 2) || (!partialMatch && ingredientCounter == recipe['ingredient'].length);
// //     }

// //     // Check category
// //     bool categoryMatch = true;
// //     if (search_category) {
// //       categoryMatch = recipe['category'].contains(searchCategory);
// //     }

// //     // Check cuisine
// //     bool cuisineMatch = true;
// //     if (search_cuisine) {
// //       cuisineMatch = recipe['cuisine'] == searchCuisine;
// //     }

// //     if (ingredientsMatch && categoryMatch && cuisineMatch) {
// //       filteredRecipes.add(recipe);
// //     }
// //   }
// //   return filteredRecipes;
// // }

// List<Map<String, dynamic>> sortRecipe(
//   List<Map<String, dynamic>> recipes,
//   String sortBy = null;
// ) {
//   if (sortBy == 'Number of Ingredient') {
//     recipes.sort((a, b) => a['ingredient'].length.compareTo(b['ingredient'].length));
//   } else if (sortBy == 'Name (Alphabetical)') {
//     recipes.sort((a, b) => a['name'].compareTo(b['name']));
//   } else if (sortBy == 'Category (Alphabetical)') {
//     recipes.sort((a, b) => a['category'].compareTo(b['category']));
//   } else if (sortBy == 'Cuisine (Alphabetical)') {
//     recipes.sort((a, b) => a['cuisine'].compareTo(b['cuisine']));
//   }
//   return recipes;
// }