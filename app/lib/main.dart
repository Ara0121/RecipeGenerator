import 'package:flutter/material.dart';
import 'camera.dart';
import 'recipe.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

// final SharedPreferences prefs = await SharedPreferences.getInstance();

void main() {
  Gemini.init(apiKey: 'AIzaSyCIxUA9BOYIgQRnRFdq7IkvOv_TS3lF3NI');
  runApp(MyApp());
}
final gemini = Gemini.instance;

class MyApp extends StatefulWidget {
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
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Search Recipes',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              setState(() {
                _suggestions = allIngredients
                    .where((ingredient) =>
                        ingredient.toLowerCase().contains(text.toLowerCase()))
                    .take(5)
                    .toList();
              });
            },
          ),
          if (_suggestions.isNotEmpty) ...[
            DropdownButton<String>(
              items: _suggestions.map((ingredient) {
                return DropdownMenuItem<String>(
                  value: ingredient,
                  child: Text(ingredient),
                );
              }).toList(),
              onChanged: (selected) {
                if (selected != null) {
                  // Handle the selected ingredient
                  print('Selected ingredient: $selected');
                }
              },
              hint: Text('Select an ingredient'),
            ),
          ],
          // Additional home page content can go here
        ],
      ),
    );
  }
}

List<String> allIngredients = [
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
  'buffalo sauce',
  'bulgur',
  'burgundy beans',
  'butter',
  'buttermilk',
  'béchamel sauce',
  'cabbage',
  'caesar dressing',
  'cannellini beans',
  'canola oil',
  'cardamom',
  'cardamom seeds',
  'carrot',
  'cashews',
  'castor oil',
  'cauliflower',
  'cayenne pepper',
  'cayenne pepper powder',
  'cedar nuts',
  'celery',
  'celery seed',
  'cheese',
  'cherry',
  'chervil',
  'chia seeds',
  'chicken',
  'chickpeas',
  'chili powder',
  'chimichurri',
  'chipotle dressing',
  'chives',
  'chutney',
  'cilantro',
  'cinnamon',
  'cinnamon powder',
  'clams',
  'cloves',
  'cobb salad dressing',
  'cocoa powder',
  'coconut',
  'coconut oil',
  'coconut water',
  'cod',
  'coffee',
  'coffee milk',
  'condensed milk',
  'coriander',
  'corn',
  'corn oil',
  'cornstarch',
  'cottage cheese',
  'couscous',
  'crab',
  'cream',
  'cream cheese',
  'creamy avocado dressing',
  'cucumber',
  'cumin',
  'curry leaves',
  'curry powder',
  'dill',
  'dried milk powder',
  'duck',
  'egg',
  'eggplant',
  'eggs',
  'elk',
  'epazote',
  'evaporated milk',
  'farro',
  'fava beans',
  'fennel',
  'fennel seeds',
  'fish',
  'flaxseed oil',
  'flaxseeds',
  'flounder',
  'flour powder',
  'fonio',
  'freekeh',
  'garbanzo beans',
  'garlic',
  'garlic powder',
  'gelatin',
  'ghee',
  'ginger',
  'ginger powder',
  'goat',
  'goose',
  'grapes',
  'grapeseed oil',
  'great northern beans',
  'greek dressing',
  'greek yogurt',
  'green beans',
  'green goddess dressing',
  'halibut',
  'ham',
  'hazelnuts',
  'heavy cream',
  'hemp oil',
  'hemp seeds',
  'herb dressing',
  'hoisin sauce',
  'hollandaise sauce',
  'honey',
  'honey mustard dressing',
  'hot chocolate',
  'hot sauce',
  'ice cream',
  'iced tea',
  'italian dressing',
  'juice',
  'kale',
  'kamut',
  'kangaroo',
  'kefir',
  'ketchup',
  'kidney beans',
  'kiwi',
  'lamb',
  'lard',
  'lavender',
  'lemon',
  'lemon balm',
  'lemon tahini dressing',
  'lemonade',
  'lentils',
  'lettuce',
  'lima beans',
  'lobster',
  'macadamia nuts',
  'mackerel',
  'mango',
  'marjoram',
  'mascarpone',
  'matcha powder',
  'mayonnaise',
  'meat',
  'milk',
  'millet',
  'mint',
  'mung beans',
  'mussels',
  'mustard',
  'mustard oil',
  'mustard powder',
  'mustard seeds',
  'navy beans',
  'nutmeg',
  'oats',
  'octopus',
  'oil dressing',
  'olive oil',
  'onion',
  'onion powder',
  'orange',
  'oregano',
  'oysters',
  'palm oil',
  'papaya',
  'paprika',
  'paprika powder',
  'parsley',
  'peach',
  'peanut oil',
  'pear',
  'peas',
  'pecans',
  'pesto',
  'pheasant',
  'pine nuts',
  'pineapple',
  'pinto beans',
  'pistachios',
  'plum',
  'pomegranate',
  'poppy seed dressing',
  'poppy seeds',
  'pork',
  'potato',
  'powdered milk',
  'protein powder',
  'pumpkin seeds',
  'quail',
  'quinoa',
  'quinoa seeds',
  'rabbit',
  'radish',
  'ranch dressing',
  'raspberry',
  'raspberry vinaigrette dressing',
  'relish',
  'rice',
  'ricotta',
  'rosemary',
  'rye',
  'safflower oil',
  'saffron',
  'sage',
  'salmon',
  'salsa',
  'salt',
  'sardines',
  'sausage',
  'scallops',
  'sea bass',
  'sesame oil',
  'sesame seeds',
  'shellfish',
  'shrimp',
  'snapper',
  'soda',
  'sorghum',
  'sorrel',
  'sour cream',
  'soy sauce',
  'soybean oil',
  'soybeans',
  'sparkling water',
  'spelt',
  'spinach',
  'split peas',
  'squid',
  'sriracha',
  'strawberry',
  'sugar powder (powdered sugar)',
  'sunflower oil',
  'sunflower seeds',
  'swordfish',
  'tahini',
  'tarragon',
  'tartar sauce',
  'tea',
  'teff',
  'teriyaki sauce',
  'thousand island dressing',
  'thyme',
  'tomato',
  'tomato sauce',
  'triticale',
  'truffle oil',
  'tuna',
  'turkey',
  'turmeric',
  'turmeric powder',
  'veal',
  'vegetable oil',
  'venison',
  'vinaigrette',
  'vinaigrette dressing',
  'vinegar dressing',
  'walnut oil',
  'walnuts',
  'water',
  'watermelon',
  'wheat',
  'whey',
  'worcestershire sauce',
  'yogurt',
  'zucchini',
];
