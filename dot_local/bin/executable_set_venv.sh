#!/bin/bash

VENV_DIR="${PWD}/venv"
REQUIREMENTS_FILE="${PWD}/requirements.txt"

# Check if virtual environment directory exists
if [ -d "$VENV_DIR" ]; then
  echo "Virtual environment already exists."
else
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"

fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"


# Check if requirements file exists
if [ -f "$REQUIREMENTS_FILE" ]; then
  # Install requirements
  pip install -r "$REQUIREMENTS_FILE"
  echo "Dependencies installed from $REQUIREMENTS_FILE."
else
  echo "Requirements file $REQUIREMENTS_FILE not found."
fi
