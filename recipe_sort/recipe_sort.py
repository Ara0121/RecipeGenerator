
import json

def sort(input):
    data = []
    ingredients = []
    # Full match
    f_match = []
    # Partial match
    p_match = []
    # Final List - sorted by cuisine
    sorted_list = []
    with open('recipe_database/recipes.json', 'r') as database:
        data = json.load(database)
    # INPUT HERE (need to change if its json file
    with open('recipe_sort/avaliable_ingredients', 'r') as input_txt:
        ingredients = input_txt.read().splitlines()
    category = ingredients[0]
    cuisine = ingredients[1]

    #Sort by ingredients
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

    #Sort by category
    match = []
    for recipe in f_match:
        category_list = recipe.get("category")
        for r_category in category_list:
            if r_category == category:
                match.append(recipe)
                break
    f_match = match

    match = []
    for recipe in p_match:
        category_list = recipe.get("category")
        for r_category in category_list:
            if r_category == category:
                match.append(recipe)
                break
    p_match = match

    #Sort by cuisine
    with open('recipe_database/cuisine.csv', 'r') as cuisines_file:
        cuisines = cuisines_file.read().splitlines()
    for cuisine_type in cuisines:
        if cuisine_type == 'cuisine':
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
        sorted_list.append(match_list)
