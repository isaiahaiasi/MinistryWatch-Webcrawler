from datetime import datetime
import csv


class Logger:
    def __init__(self):
        self.logs = []

    def log(self, log_msg: object):
        self.logs.append({
            'timestamp': datetime.now(),
            **log_msg
        })

    def write(self, fields: list):
        timestamp = datetime.now().strftime('%d-%m-%y_%H:%M:%S')
        with open(f"data/log_{timestamp}.csv", "w") as f:
            fieldnames = ['timestamp', *fields]
            writer = csv.DictWriter(f, fieldnames, quoting=csv.QUOTE_MINIMAL)
            writer.writeheader()
            writer.writerows(self.logs)
