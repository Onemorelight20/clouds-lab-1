import boto3
import pymysql
import json
import decimal
import datetime

ssm = boto3.client('ssm')

db_host = ssm.get_parameter(Name='/iot/db_host', WithDecryption=True)['Parameter']['Value']
db_user = ssm.get_parameter(Name='/iot/db_user', WithDecryption=True)['Parameter']['Value']
db_password = ssm.get_parameter(Name='/iot/db_password', WithDecryption=True)['Parameter']['Value']
db_name = ssm.get_parameter(Name='/iot/db_name', WithDecryption=True)['Parameter']['Value']


class CustomEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            return float(obj)
        if isinstance(obj, datetime.datetime):
            return obj.isoformat()
        return super(CustomEncoder, self).default(obj)


def lambda_handler(event, context):
    with pymysql.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        database=db_name,
        connect_timeout=10,
    ) as conn, conn.cursor() as cursor:
        if 'queryStringParameters' in event and'sensor_type' in event['queryStringParameters']:
            sensor_type = event['queryStringParameters']['sensor_type']

            if sensor_type not in ['temperature', 'humidity', 'light']:
                return {
                    'statusCode': 400,
                    'body': json.dumps({'error': f'Invalid sensor_type: {sensor_type}'})
                }

            table_name = f'{sensor_type}_sensor_data'
            try:
                select_query = f"SELECT * FROM {table_name} WHERE sensor_type = %s"
                from_timestamp = event['queryStringParameters'].get('from', '')
                to_timestamp = event['queryStringParameters'].get('to', '')
                params = [sensor_type]
                if from_timestamp:
                    select_query += ' AND timestamp >= %s'
                    params.append(from_timestamp)
                if to_timestamp:
                    select_query += ' AND timestamp <= %s'
                    params.append(to_timestamp)
                cursor.execute(select_query, params)
                records = cursor.fetchall()
                columns = [desc[0] for desc in cursor.description]
                result = []
                for row in records:
                    result.append(dict(zip(columns, row)))
                return {
                    'statusCode': 200,
                    'body': json.dumps(result, cls=CustomEncoder)
                }
            except Exception as e:
                return {
                    'statusCode': 500,
                    'body': json.dumps({'error': f"Error querying data from {table_name}: {e}"})
                }
        else:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'sensor_type is required'})
            }
