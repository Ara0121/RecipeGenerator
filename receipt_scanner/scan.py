import google.generativeai as genai
import PIL.Image
import pandas as pd

from flask import Flask, jsonify, request
import base64

app = Flask(__name__)

@app.route('/scan', methods=['POST'])
def scan_receipt(image_path):
    df_ingredient = pd.read_csv('recipe_database/ingredient.csv')
    ingredients = str(df_ingredient['ingredient'].tolist())
    
    try:
        data = request.get_json()
        image_data = data['image']
        image_bytes = base64.b64decode(image_data)
        image_path = os.path.join('uploaded_images', f"{filename}.jpg")
        
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
    
    except Exception as e:
        return jsonify(debug=True, port=5000)
    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

