from flask import Flask, render_template, url_for, __version__
import os
import platform
from datetime import datetime


app = Flask(__name__)


def os_parse():
    with open("/etc/os-release") as f:
        d = {}
        for line in f:
            k, v = line.rstrip().split("=")
            # .strip('"') will remove if there or else do nothing
            d[k] = v.strip('"')
        return d


@app.route('/')
def index():
    return render_template('index.html', machine=os.uname(),
                           os_type=os_parse()['PRETTY_NAME'],
                           today=datetime.now(),
                           pyver=platform.python_version(),
                           flaskv=__version__)


if __name__ == "__main__":
    # app.run(debug=False)
    app.run()
