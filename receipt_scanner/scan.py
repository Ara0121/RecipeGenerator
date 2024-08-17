import google.generativeai as genai
import PIL.Image
import pandas as pd


def scan_recipe(image_path):
    df_ingredient = pd.read_csv('recipe_database/ingredient.csv')
    ingredients = str(df_ingredient['ingredient'].tolist())
    
    image = PIL.Image.open(image_path)
    prompt = f"""
List product names on the receipt from products listed in this list. If product is not in the list, skip it.

{ingredients}

Only return the type of product, remove the description

Example output:
apple
banana
salt
"""
    
    genai.configure(api_key='AIzaSyCIxUA9BOYIgQRnRFdq7IkvOv_TS3lF3NI')
    model = genai.GenerativeModel('gemini-1.5-flash')
    
    response = model.generate_content([prompt, image])
    
    return response.text.lower().strip()
  

