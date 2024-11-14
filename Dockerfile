FROM python:3.10

RUN pip install --upgrade pip

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

WORKDIR /app
COPY Services Services
COPY Models Models
COPY Backend Backend
COPY Main.py .

ENTRYPOINT ["python", "./Main.py"]