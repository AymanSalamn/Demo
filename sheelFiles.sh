name: CI Workflow

on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main

jobs:
  run-api-tests-pr:
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.9'  # specify your Python version

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Get changed files
        id: changed-files
        run: |
          git fetch origin main  # Ensure we have the latest main branch
          CHANGED_FILES=$(git diff --name-only ${{ github.event.pull_request.base.sha }} ${{ github.sha }})
          echo "CHANGED_FILES=$CHANGED_FILES"
          echo "CHANGED_FILES=$CHANGED_FILES" >> $GITHUB_ENV

      - name: Filter and run tests
        run: |
          test_files=""  
          for file in $CHANGED_FILES; do
            if [[ "$file" == *"test_"* ]]; then
              test_files="$test_files $file"
              pytest $file
            fi
          done

          # If there are any test files, run pytest with all of them
          if [[ -n "$test_files" ]]; then
              echo "Pytest $test_files"
              pytest $test_files
          fi  
          

  run-command-push:
    if: github.event_name == 'push'
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.9'  # specify your Python version

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run additional command on push
        run: |
          echo "Running additional commands on push"
          # Add your custom commands here
          pytest
