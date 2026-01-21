import json
import random
import datetime

# 模擬真實爬蟲腳本
def fetch_toyota_price(model_name):
    # TODO: Implement actual scraping logic
    print(f"Scraping Toyota website for {model_name}...")
    base_price = 885000 if 'Altis' in model_name else 930000
    return base_price

def fetch_ford_price(model_name):
    print(f"Scraping Ford website for {model_name}...")
    return 979000

def fetch_honda_price(model_name):
    print(f"Scraping Honda website for {model_name}...")
    return 1059000

def main():
    # 原始資料結構 (Updated with new fields)
    vehicles = [
        {
            "id": "v1",
            "brand": "Toyota",
            "model": "Corolla Altis 1.8 汽油尊爵",
            "price": 0,
            "displacement": 1798,
            "horsepower": 140.0,
            "torque": 17.5,
            "avgFuelConsumption": 14.9,
            "transmission": "Super CVT-i 無段變速",
            "frontSuspension": "麥花臣",
            "rearSuspension": "扭力樑",
            "engineType": "自然進氣",
            "maintenanceCost60k": 24000,
            "partsPrices": {"前保桿": 4500, "頭燈總成": 6000, "照後鏡": 2500},
            "reliabilityScore": 92
        },
        {
            "id": "v2",
            "brand": "Ford",
            "model": "Focus 5D ST-Line Vignale",
            "price": 0,
            "displacement": 1497,
            "horsepower": 182.0,
            "torque": 24.5,
            "avgFuelConsumption": 16.7,
            "transmission": "SelectShift™ 8速手自排",
            "frontSuspension": "麥花臣",
            "rearSuspension": "多連桿",
            "engineType": "渦輪增壓",
            "maintenanceCost60k": 35040,
            "partsPrices": {"前保桿": 5500, "頭燈總成": 12000, "照後鏡": 3500},
            "reliabilityScore": 78
        },
        {
            "id": "v3",
            "brand": "Honda",
            "model": "CR-V 1.5 VTi-S",
            "price": 0,
            "displacement": 1498,
            "horsepower": 193.0,
            "torque": 24.8,
            "avgFuelConsumption": 14.7,
            "transmission": "CVT 無段變速",
            "frontSuspension": "麥花臣",
            "rearSuspension": "多連桿",
            "engineType": "渦輪增壓",
            "maintenanceCost60k": 30497,
            "partsPrices": {"前保桿": 6500, "頭燈總成": 9500, "照後鏡": 4000},
            "reliabilityScore": 88
        },
        {
            "id": "v4",
            "brand": "Toyota",
            "model": "Corolla Altis Hybrid 旗艦",
            "price": 0,
            "displacement": 1798,
            "horsepower": 122.0,
            "torque": 14.5,
            "avgFuelConsumption": 25.3,
            "transmission": "E-CVT 電子控制無段變速",
            "frontSuspension": "麥花臣",
            "rearSuspension": "扭力樑",
            "engineType": "油電混合",
            "maintenanceCost60k": 26000,
            "partsPrices": {"前保桿": 4500, "頭燈總成": 8000, "照後鏡": 2500},
            "reliabilityScore": 94
        }
    ]

    print(f"[{datetime.datetime.now()}] Starting price update job...")

    for v in vehicles:
        if v['brand'] == 'Toyota':
            v['price'] = fetch_toyota_price(v['model'])
        elif v['brand'] == 'Ford':
            v['price'] = fetch_ford_price(v['model'])
        elif v['brand'] == 'Honda':
            v['price'] = fetch_honda_price(v['model'])
        
        print(f"Updated {v['brand']} {v['model']} price to: ${v['price']}")

    # 輸出 JSON 檔案
    with open('vehicles.json', 'w', encoding='utf-8') as f:
        json.dump(vehicles, f, ensure_ascii=False, indent=2)

    print("Update complete. 'vehicles.json' generated.")

if __name__ == "__main__":
    main()