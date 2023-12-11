from flask import Flask, request, render_template, redirect
import threading
import time
import logging

from utils import generate_sensor_data
from queue_utils import send_sensor_data, sqs_queue_url

app = Flask(__name__)
sensor_configurations = {}
sensor_threads = {}


def emulate_sensor(sensor_type, frequency, data_address):
    while True:
        if sensor_type in sensor_configurations:
            data = generate_sensor_data(sensor_type)
            app.logger.info(f"Sending {data}")
            send_sensor_data(data, data_address)
            time.sleep(frequency / 1000)
            if sensor_configurations[sensor_type]['stop_flag']:
                del sensor_configurations[sensor_type]
                break
        else:
            time.sleep(1)


@app.post('/')
def post_index():
    sensor_type = request.form['sensor_type']
    frequency = int(request.form['frequency'])
    data_address = request.form['data_address']

    if sensor_type in sensor_configurations:
        sensor_configurations[sensor_type]['stop_flag'] = True
    
    thread = threading.Thread(target=emulate_sensor, args=(sensor_type, frequency, data_address))
    sensor_threads[sensor_type] = thread
    thread.start()

    sensor_configurations[sensor_type] = {
        'frequency': frequency,
        'data_address': data_address,
        'stop_flag': False
    }

    return redirect('/')


@app.get('/')
def get_index():
    return render_template('index.html', configurations=sensor_configurations,
                           sqs_queue_url=sqs_queue_url)


@app.post('/stop')
def stop_sensor():
    sensor_type = request.form['sensor_type']
    if sensor_type in sensor_threads:
        config = sensor_configurations[sensor_type]
        config['stop_flag'] = True
        del sensor_threads[sensor_type]
    return redirect('/')


if __name__ == '__main__':
    app.logger.setLevel(logging.INFO)
    app.run(host="0.0.0.0")

