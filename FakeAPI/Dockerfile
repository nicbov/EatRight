FROM python:3.10

RUN pip install --upgrade pip

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

WORKDIR /app
COPY data data
COPY Main.py .

EXPOSE 3001
ENTRYPOINT ["python", "Main.py", "--mode", "replay", "--static-root", "data/api.spoonacular.com"]