from flask import Flask, request, jsonify
import io
import google.generativeai as genai
import PIL.Image
import pandas as pd


app = Flask(__name__)

def scan_receipt(image_path):
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
  
  
@app.route('/scan', methods=['POST'])
def scan():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        image = io.BytesIO(file.read())
        result = scan_receipt(image)
        return jsonify({'result': result})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)