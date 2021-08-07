from datetime import datetime

import argparse
import random
import time
import socket

puntos_control = [
    'A7-KM-01',
    'A7-KM-15',
    'A7-KM-30',
    'A7-KM-50',
    ]
matriculas = [
    '1234AAA',
    '1234EEE',
    '1234UUU'
    ]
def create_data():
    random.seed(datetime.utcnow().microsecond)
    dt = datetime.utcnow()\
        .strftime('%Y-%m-%d %H:%M:%S.%f')
    punto = random.choice(puntos_control)
    vehiculo = random.choice(matriculas)
    return '{} {}\n'.format(vehiculo, punto).encode('utf-8')

def randomize_interval(interval):
    """
    Returns a random value sligthly different
    from the orinal interval parameter
    """
    random.seed(datetime.utcnow().microsecond)
    delta = interval + random.uniform(-0.1, 0.9)
    # delay can not be 0 or negative
    if delta <= 0:
        delta = interval
    return delta

def initialize(port=9876, interval=1):
    """
    Initialize a TCP server that returns a non deterministic
    flow of simulated events to its clients
    """
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_address = ('localhost', port)
    sock.bind(server_address)
    sock.listen(5)
    print("Listening at {}".format(server_address))
    try:
        connection, client_address = sock.accept()
        print('connection from', client_address)
        while True:
            line = create_data()
            connection.sendall(line)
            print(line)
            time.sleep(randomize_interval(interval))
    except Exception as e:
        print(e)

    finally:
        sock.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--port', required=False, default=9876,
        help='Port (default=9876)', type=int)

    parser.add_argument(
        '--interval', required=False, default=1,
        help='Interval in seconds (default=1)', type=float)

    args, extra_params = parser.parse_known_args()
    initialize(port=args.port, interval=args.interval)


if __name__ == '__main__':
    main()
