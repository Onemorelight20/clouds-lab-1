from lambda_function import lambda_handler


if __name__ == "__main__":
    event = { 'queryStringParameters': {
        'sensor_type': 'temperature',
        'to': '2023-10-04T01:18:40'
    }
    }
    result = lambda_handler(event, None)
    print(result)
