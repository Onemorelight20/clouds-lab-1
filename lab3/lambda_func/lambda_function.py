import json
import pymysql
import boto3

ssm = boto3.client('ssm')

db_host = ssm.get_parameter(Name='/iot/db_host', WithDecryption=True)['Parameter']['Value']
db_user = ssm.get_parameter(Name='/iot/db_user', WithDecryption=True)['Parameter']['Value']
db_password = ssm.get_parameter(Name='/iot/db_password', WithDecryption=True)['Parameter']['Value']
db_name = ssm.get_parameter(Name='/iot/db_name', WithDecryption=True)['Parameter']['Value']


def lambda_handler(event, context):
    with pymysql.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        database=db_name,
        connect_timeout=10,
    ) as conn, conn.cursor() as cursor:
        for record in event['Records']:
            message_body = json.loads(record['body'])
            sensor_type = message_body['sensor_type']

            if sensor_type == 'temperature':
                table_name = 'temperature_sensor_data'
                field_name = 'temp_celsius'
            elif sensor_type == 'humidity':
                table_name = 'humidity_sensor_data'
                field_name = 'value'
            elif sensor_type == 'light':
                table_name = 'light_sensor_data'
                field_name = 'value_lux'
            else:
                raise ValueError(f'No sensor_type={sensor_type} logic implemented')

            try:
                insert_query = f"INSERT INTO {table_name} (sensor_type, {field_name}, location, timestamp) VALUES (%s, %s, %s, %s)"
                cursor.execute(
                    insert_query,
                    (sensor_type, message_body[field_name], message_body['location'], message_body['timestamp'])
                )
                conn.commit()
            except Exception as e:
                print(f"Error inserting data into {table_name}: {e}")
