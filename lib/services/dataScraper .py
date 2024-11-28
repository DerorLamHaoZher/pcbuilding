from flask import Flask, jsonify
from flask_cors import CORS
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import time
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from pymongo import MongoClient
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Update MongoDB setup with correct URL
client = MongoClient('mongodb://localhost:27017/')  # MongoDB default port
db = client['pc_parts_db']  # database name
collection = db['products'] 

# Define category keywords
CATEGORY_KEYWORDS = {
    "CPU": ["cpu", "processor", "ryzen", "intel core"],
    "Motherboard": ["motherboard", "mobo"],
    "GPU": ["gpu", "graphics card", "nvidia", "geforce", "radeon"],
    "RAM": ["ram", "memory", "ddr"],
    "ROM": ["ssd", "hdd", "hard drive", "nvme"],
    "Case": ["case", "chassis"],
    "Case Fan": ["fan", "cooler fan", "case fan"],
    "CPU Cooler": ["cpu cooler", "heatsink", "aio", "liquid cooler"],
    "PSU": ["psu", "power supply", "gold power", "bronze power", "watt", "modular"]
}

def categorize_product(product_name):
    product_name_lower = product_name.lower()
    for category, keywords in CATEGORY_KEYWORDS.items():
        if any(keyword in product_name_lower for keyword in keywords):
            return category
    return "Other"

def scrape_product_info():
    print("Starting web scraping...")
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    product_data = []
    page_num = 1
    
    while True:
        url = f'https://www.racuntech.com/c/computer-parts?ppg=96&page={page_num}'
        print(f"Scraping page {page_num}...")
        driver.get(url)

        try:
            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, '.ict-catalog-item-wrap'))
            )
        except Exception as e:
            print(f"Error waiting for page load: {e}")
            break

        product_items = driver.find_elements(By.CSS_SELECTOR, '.ict-catalog-item-wrap')
        if not product_items:
            break

        for item in product_items:
            try:
                product_name_element = item.find_element(By.CSS_SELECTOR, '.open-ict-product.product_name')
                product_name = product_name_element.text.strip() if product_name_element else "Unknown Product"
                price_element = item.find_element(By.CSS_SELECTOR, '.oe_currency_value')
                price = price_element.text.strip() if price_element else "Price not available"
                
                category = categorize_product(product_name)
                
                product_data.append({
                    'product_name': product_name,
                    'price': price,
                    'category': category,
                    'scraped_at': datetime.now().isoformat()
                })
            except Exception as e:
                print(f"Error extracting data for item: {e}")

        page_num += 1

    driver.quit()
    print(f"Scraping completed. Found {len(product_data)} products")
    return product_data

@app.route('/')
def index():
    return "Welcome to the Product Info Scraper API!"

@app.route('/products', methods=['GET'])
def get_products():
    try:
        products = list(collection.find({}, {'_id': 0, 'product_name': 1, 'price': 1, 'category': 1}))
        
        if not products:
            print("No data in database, running scraper...")
            products = scrape_product_info()
            if products:
                collection.delete_many({})
                collection.insert_many(products)
                print(f"Scraped and saved {len(products)} products")
        
        return jsonify(products)
    except Exception as e:
        print(f"Error in get_products: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/scrape', methods=['GET'])
def scrape():
    try:
        products = scrape_product_info()
        if products:
            collection.delete_many({})
            collection.insert_many(products)
            return jsonify(products)
        return jsonify({"error": "No products found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/check-db', methods=['GET'])
def check_db():
    try:
        count = collection.count_documents({})
        sample = list(collection.find({}).limit(5))
        for doc in sample:
            doc['_id'] = str(doc['_id'])
        return jsonify({
            'total_documents': count,
            'sample_data': sample
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("Starting application...")
    print("Running initial scrape...")
    
    try:
        # Always run scraper on startup
        products = scrape_product_info()
        if products:
            # Clear old data and save new data
            collection.delete_many({})
            collection.insert_many(products)
            print(f"Initial scrape completed. Saved {len(products)} products to database at mongodb://localhost:27017/pc_parts_db/products")
        else:
            print("No products found during initial scrape")
    except Exception as e:
        print(f"Error during initial scrape: {e}")
    
    # Start the Flask server
    print("Starting Flask server...")
    app.run(debug=True, host="0.0.0.0", port=5000)  # Changed port to match MongoDB

