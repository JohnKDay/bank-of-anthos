# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
#   https://github.com/GoogleCloudPlatform/python-docker
#FROM gcr.io/google-appengine/python
#FROM python:latest

FROM ubuntu:18.04
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
#RUN apt-get update && apt-get install -y python3 python3-pip python3-venv python3-virtualenv python3-wheel
RUN apt-get update
#RUN apt-cache search python3
RUN apt-get install -y python3.7 python3-virtualenv
#RUN apt-get update && apt-get install -y python3 python3-pip python3-venv python3-virtualenv python3-wheel


#RUN dpkg -L python3
#RUN dpkg -L python3-venv
#RUN dpkg -L python3-virtualenv
#RUN apt-get update
#RUN apt-get install -y python3 python3-pip

RUN python3 -V

#RUN pip3 install --upgrade pip
#RUN pip3 install --user virtualenv wheel

# show python logs as they occur
ENV PYTHONUNBUFFERED=0

# Create a virtualenv for the application dependencies.
#RUN venv -p python3.7 /env
#RUN python3 -m venv -p python3.7 /env
#RUN virtualenv -p python3.7 /env
RUN python3 -m virtualenv -p /usr/bin/python3.7 /env

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate. This ensures the application is executed within
# the context of the virtualenv and will have access to its dependencies.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# explicitly set a fallback log level in case no log level is defined by Kubernetes
ENV LOG_LEVEL info

# Install dependencies.
ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

# This is a workaround to use an unreleased version of grpcio, so that the cloud trace exporter and the OpenTelemetry RequestsInstrumentor do not create an infinite request loop.
RUN pip install --pre --upgrade --force-reinstall --extra-index-url \
    https://packages.grpc.io/archive/2020/06/635ded1749f990ffe6be0ca403e4b255cf62742f-983cbea2-bebc-4777-911c-14e4cb494b92/python \
    grpcio

# Add application code.
ADD static /app/static
ADD templates /app/templates
ADD *.py /app/

# Copy logging configuration for gunicorn
COPY logging.conf /logging.conf

WORKDIR /app
# Start server using gunicorn
CMD gunicorn -b :$PORT --threads 4 --log-config /logging.conf --log-level=$LOG_LEVEL "frontend:create_app()"
