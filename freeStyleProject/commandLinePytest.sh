#!/bin/bash

# Install Allure 
current_dir=$(pwd)
wget -q -nv https://github.com/allure-framework/allure2/releases/download/2.27.0/allure-2.27.0.tgz
tar -zxf allure-2.27.0.tgz -C "$current_dir" > /dev/null
allure_dir="$current_dir/allure-2.27.0"
ln -sf "$allure_dir"/bin/allure /usr/bin/allure

# Run Tests
#pytest --alluredir=report_results_json
command="$pytest_command --alluredir=$results_dir_name"
# Execute the concatenated command
$command


# Generate Allure Report
report_results_dir_html="${results_dir_name}_html"
"$allure_dir"/bin/allure  generate --clean --single-file $results_dir_name -o $report_results_dir_html

# Compressed Report Results
zip -r "${report_results_dir_html}.zip" $report_results_dir_html

# Set Directory name
DIR_NAME=$(date +%Y-%m-%d)
mkdir -p "$DIR_NAME"
cd "$DIR_NAME"
SUB_DIR=$results_dir_name
mkdir -p "$SUB_DIR"
cd ..

# Move Directory
mv "${report_results_dir_html}.zip" "$DIR_NAME/$SUB_DIR"

# printenv

# Upload to S3
AWS_S3_BUCKET="pytest-allure-report-results"
AWS_REGION="us-east"
expiry_seconds=3600

export AWS_ACCESS_KEY_ID='$AWS_ACCESS_KEY'
export AWS_SECRET_ACCESS_KEY='$AWS_SECRET_KEY'

aws s3 cp "$DIR_NAME/$SUB_DIR/${report_results_dir_html}.zip" s3://"$AWS_S3_BUCKET"/"$DIR_NAME"/"$SUB_DIR/"

# url=$(aws s3 presign s3://"$AWS_S3_BUCKET"/"$DIR_NAME"/"$SUB_DIR/${report_results_dir_html}.zip" --expires-in $expiry_seconds)
# echo "Download URL: $url"
