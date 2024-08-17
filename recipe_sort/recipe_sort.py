
import json


def sort_ing(data, ingredients):
    for recipe in data:
        recipe_ing = recipe.get("ingredient")
        counter = 0
        for ing in recipe_ing:
            if ing.get("name") in ingredients:
                counter += 1
        if counter == len(recipe_ing):
            f_match.append(recipe)
        elif counter > 0:
            p_match.append(recipe)

def sort_category(match_list, category):
    for recipe in match_list:
        if recipe.get("category") != category:
            match_list.remove(recipe)

data = []
ingredients = []
#Full match
f_match = []
#Partial match
p_match = []
with open('recipe_database/pinchofyum/recipe_database.json', 'r') as database:
    data = json.load(database)
with open('recipe_sort/avaliable_ingredients', 'r') as input_txt:
    ingredients = input_txt.read().splitlines()

sort_ing(data, ingredients)
sort_category(f_match, 'Dessert')
sort_category(p_match, 'Dessert')
#print(f_match)
print(p_match)

database.close()
input_txt.close()