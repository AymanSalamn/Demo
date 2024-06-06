#!/bin/bash

# Run Tests
pytest --alluredir=report_results_json

# Generate Allure Report 
allure generate --clean --single-file report_results_json -o report_results_html

# Compressed Report Results
zip -r report_results.zip report_results_html


# Set Directory name
DIR_NAME=$(date +%Y-%m-%d)
mkdir -p "$DIR_NAME"
cd "$DIR_NAME"
SUB_DIR=$(date +%H-%M-%S)
mkdir -p "$SUB_DIR"
cd ..

# Move Directory
mv report_results.zip "$DIR_NAME/$SUB_DIR"
