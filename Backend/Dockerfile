FROM python:3.10

RUN pip install --upgrade pip

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

WORKDIR /app
COPY *.py .
COPY data/ data/
COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]