import json
import boto3
from utils import generate_sensor_data

ssm = boto3.client('ssm', region_name='us-east-1')
sqs = boto3.client('sqs', region_name='us-east-1')

sqs_queue_url = ssm.get_parameter(
    Name='/iot/devices-queue-url',
    WithDecryption=False
)['Parameter']['Value']


def send_sensor_data(data, data_address):
    response = sqs.send_message(
        QueueUrl=data_address,
        MessageBody=json.dumps(data)
    )
    
    return response


# Local testing
if __name__ == "__main__":
    # data = generate_sensor_data("temperature")
    # print(data)
    data = {"sensor_type": "air_pollution_sensor"}
    print(send_sensor_data(data, sqs_queue_url))
