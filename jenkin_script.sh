#!/bin/bash

# Process and Upload Report

# Clone repository
git clone https://github.com/${{ github.repository }}.git
cd $(basename "${{ github.repository }}")

# Set up Python
sudo apt update
sudo apt install python3.9 python3-pip -y

# Install Java
sudo apt update
sudo apt install default-jdk -y

# Download and Install Allure
wget https://github.com/allure-framework/allure2/releases/download/2.27.0/allure-2.27.0.tgz
sudo tar -zxvf allure-2.27.0.tgz -C /opt/
sudo ln -s /opt/allure-2.27.0/bin/allure /usr/bin/allure

# Install dependencies
python3 -m pip install --upgrade pip
pip install -r requirements.txt

# Generate report
pytest --alluredir=ReportResultsFilesTest

# Run Allure command
allure generate --clean --single-file ReportResultsFilesTest -o ReportResults

# Set directory name
DIR_NAME=$(date +%Y-%m-%d)
echo "DIR_NAME=\"$DIR_NAME\"" >>$GITHUB_ENV
mkdir -p "$DIR_NAME"
cd "$DIR_NAME"
SUB_DIR=$(date +%H-%M-%S)
echo "SUB_DIR=\"$SUB_DIR\"" >>$GITHUB_ENV
mkdir -p "$SUB_DIR"

# Compress files
zip -r report_results.zip ../ReportResults

# Move files to the new directory
mv report_results.zip "${DIR_NAME}/${SUB_DIR}"

# Upload to S3
aws s3 sync "${DIR_NAME}/${SUB_DIR}" s3://${{ secrets.AWS_S3_BUCKET }}/${DIR_NAME}/${SUB_DIR} --region ${{ secrets.AWS_REGION }} --delete
