#!/bin/bash

# Check if the event is a pull request or push to main branch
if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then
    CHANGED_FILES=$(git diff --name-only ${{ github.event.pull_request.base.sha }} ${{ github.sha }})
fi

echo "CHANGED_FILES=$CHANGED_FILES"
echo "CHANGED_FILES=$CHANGED_FILES" >> $GITHUB_ENV

# Assuming the script is executed on Ubuntu-latest, perform setup and testing
echo "Running on Ubuntu-latest"

# Checkout repository
echo "Checking out repository"
git fetch origin main

# Filter and run tests on changed files
test_files=""
for file in $CHANGED_FILES; do
    if [[ "$file" == *"test_"* ]]; then
        test_files="$test_files $file"
        echo "Running tests in $file"
        pytest $file
    fi
done

# If there are any test files, run pytest with all of them
if [[ -n "$test_files" ]]; then
    echo "Running Pytest on files: $test_files"
    pytest $test_files
fi
