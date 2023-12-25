CREATE SCHEMA sensor_warehouse;

USE sensor_warehouse;

-- Create the temperature sensor data table
CREATE TABLE temperature_sensor_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_type VARCHAR(255),
    temp_celsius DECIMAL(5, 2),
    location VARCHAR(255),
    timestamp TIMESTAMP
);

-- Create the humidity sensor data table
CREATE TABLE humidity_sensor_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_type VARCHAR(255),
    value DECIMAL(5, 2),
    location VARCHAR(255),
    timestamp TIMESTAMP
);

-- Create the light sensor data table
CREATE TABLE light_sensor_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_type VARCHAR(255),
    value_lux DECIMAL(5, 2),
    location VARCHAR(255),
    timestamp TIMESTAMP
);
