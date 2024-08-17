
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
        elif counter > (len(recipe_ing) / 2):
            p_match.append(recipe)

def sort_category(match_list, category):
    for recipe in match_list:
        category_list = recipe.get("category")
        for r_category in category_list:
            if r_category != category:
                match_list.remove(recipe)
                break

data = []
ingredients = []
#Full match
f_match = []
#Partial match
p_match = []
with open('recipe_database/recipes.json', 'r') as database:
    data = json.load(database)
with open('recipe_sort/avaliable_ingredients', 'r') as input_txt:
    ingredients = input_txt.read().splitlines()

sort_ing(data, ingredients)
#print(p_match)
#sort_category(f_match, 'dessert')
sort_category(p_match, 'dessert')
#print(f_match)
for r in p_match:
    print(r)
database.close()
input_txt.close()