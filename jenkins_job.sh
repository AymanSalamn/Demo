#!/bin/bash

# Process and Upload Report

# Run Pytest
pytest 

# Generate report
pytest --alluredir=ReportResultsFilesTest

# # Run Allure command
# allure generate --clean --single-file ReportResultsFilesTest -o ReportResults

# # Set directory name
# DIR_NAME=$(date +%Y-%m-%d)
# echo "DIR_NAME=\"$DIR_NAME\"" >>$GITHUB_ENV
# mkdir -p "$DIR_NAME"
# cd "$DIR_NAME"
# SUB_DIR=$(date +%H-%M-%S)
# echo "SUB_DIR=\"$SUB_DIR\"" >>$GITHUB_ENV
# mkdir -p "$SUB_DIR"

# # Compress files
# zip -r report_results.zip ../ReportResults

# # Move files to the new directory
# mv report_results.zip "${DIR_NAME}/${SUB_DIR}"

# # Upload to S3
# aws s3 sync "${DIR_NAME}/${SUB_DIR}" s3://${{ secrets.AWS_S3_BUCKET }}/${DIR_NAME}/${SUB_DIR} --region ${{ secrets.AWS_REGION }}
