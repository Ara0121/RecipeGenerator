
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
    match = []
    for recipe in match_list:
        category_list = recipe.get("category")
        for r_category in category_list:
            if r_category == category:
                match.append(recipe)
                break
    return match

def sort_cuisine(cuisine_list, f_match, p_match):
    with open('recipe_database/cuisine.csv', 'r') as cuisines_file:
        cuisines = cuisines_file.read().splitlines()
    for cuisine in cuisines:
        if cuisine == 'cuisine':
            continue
        f_match_c = []
        p_match_c = []
        match_list = []
        for recipe in f_match:
            if recipe.get('cuisine') == cuisine:
                f_match_c.append(recipe)
        for recipe in p_match:
            if recipe.get('cuisine') == cuisine:
                p_match_c.append(recipe)
        match_list.append(cuisine)
        match_list.append(f_match_c)
        match_list.append(p_match_c)
        cuisine_list.append(match_list)





data = []
ingredients = []
#Full match
f_match = []
#Partial match
p_match = []
#Final List - sorted bu cuisine
cuisine_list = []
with open('recipe_database/recipes.json', 'r') as database:
    data = json.load(database)
with open('recipe_sort/avaliable_ingredients', 'r') as input_txt:
    ingredients = input_txt.read().splitlines()

sort_ing(data, ingredients)
#print(f_match)
f_match = sort_category(f_match, 'dessert')
p_match = sort_category(p_match, 'dessert')
database.close()
sort_cuisine(cuisine_list, f_match, p_match)
#print(f_match)
for c in cuisine_list:
    print(f"{c[0]}:")
    print("FULL MATCH:")
    for f in c[1]:
        print(f)
    print("PARTIAL MATCH:")
    for p in c[2]:
        print(p)
input_txt.close()
