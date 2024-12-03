#!/usr/bin/bash

cd /app/data
python ./tableCreator.py
python ./dataPusher.py

cd /app
exec python ./Main.py
