from lambda_function import lambda_handler


# test that lambda successfully saves sqs messages into rds
if __name__ == "__main__":
    event = {
        'Records': [
            {
                'body': '{"sensor_type": "temperature", "temp_celsius": 25.0, "location": "(-66.380, -1.000)", "timestamp": "2021-05-04 20:55:29"}'
            },
            {
                'body': '{"sensor_type": "humidity", "value": 50.0, "location": "(-66.380, -1.000)", "timestamp": "2021-05-04 20:55:29"}'
            },
            {
                'body': '{"sensor_type": "light", "value_lux": 500.0, "location": "(-66.380, -1.000)", "timestamp": "2021-05-04 20:55:29"}'
            }
        ]
    }
    lambda_handler(event, None)
