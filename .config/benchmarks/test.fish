#!/bin/fish
python -m venv venv
source venv/bin/activate.fish
pip install -r requirements.txt
./run_test.py
