#!/usr/bin/bash

cd /app/data
python ./tableCreator.py
python ./dataPusher.py

cd /app
python ./Main.py
