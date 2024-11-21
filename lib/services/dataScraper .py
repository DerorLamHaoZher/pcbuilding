from flask import Flask, jsonify
from flask_cors import CORS  # Import CORS module
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import time
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

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



# Function to determine the category of a product
def categorize_product(product_name):
    product_name_lower = product_name.lower()
    for category, keywords in CATEGORY_KEYWORDS.items():
        if any(keyword in product_name_lower for keyword in keywords):
            return category
    return "Other"  # Default category if no match is found



# Scraping function to get product names and prices
def scrape_product_info():
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    product_data = []
    page_num = 1
    while True:
        url = f'https://www.racuntech.com/c/computer-parts?ppg=96&page={page_num}'
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

                # Categorize the product
                category = categorize_product(product_name)

                product_data.append({
                    'product_name': product_name,
                    'price': price,
                    'category': category
                })
            except Exception as e:
                print(f"Error extracting data for item: {e}")

        page_num += 1

    driver.quit()
    return product_data


@app.route('/')
def index():
    return "Welcome to the Product Info Scraper API! Visit /scrape to get the product data."

@app.route('/scrape', methods=['GET'])
def scrape():
    try:
        product_data = scrape_product_info()
        if not product_data:
            return jsonify({"error": "No product data found"}), 404
        return jsonify(product_data)
    except Exception as e:
        print(f"Error in scraping: {e}")
        return jsonify({"error": "Failed to scrape data"}), 500

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)  # Listen on all interfaces
