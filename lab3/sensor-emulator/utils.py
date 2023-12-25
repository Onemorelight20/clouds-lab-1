import random
import time


def generate_random_coordinates(min_lat=-90, max_lat=90, min_lon=-18, max_lon=180, decimal_places=3):
    latitude = random.uniform(min_lat, max_lat)
    longitude = random.uniform(min_lon, max_lon)
    return f"{latitude:.{decimal_places}f},{longitude:.{decimal_places}f}"


def generate_sensor_data(sensor_type: str):
    location = generate_random_coordinates()
    if sensor_type == "temperature":
        return {
            "sensor_type": sensor_type,
            "temp_celsius": round(random.uniform(10, 40), 2),
            "location": location,
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    elif sensor_type == "humidity":
        return {
            "sensor_type": sensor_type,
            "value": round(random.uniform(30, 70), 2),
            "location": location,
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    elif sensor_type == "light":
        return {
            "sensor_type": sensor_type,
            "value_lux": round(random.uniform(0, 1000), 2),
            "location": location,
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
    else:
        return {}

