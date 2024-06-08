#!/bin/bash


# install java
apt install default-jdk -y


current_dir=$(pwd)
wget https://github.com/allure-framework/allure2/releases/download/2.27.0/allure-2.27.0.tgz
tar -zxvf allure-2.27.0.tgz -C "$current_dir"
allure_dir="$current_dir/allure-2.27.0"
#ln -sf "$allure_dir"/bin/allure /usr/bin/allure

# Check Allure version
"$allure_dir"/bin/allure --version


# Run Tests
pytest --alluredir=report_results_json

# Generate Allure Report 
"$allure_dir"/bin/allure  generate --clean --single-file report_results_json -o report_results_html

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
