#!/bin/bash

# Check if a path is provided.
if [ -z "$1" ]; then
    echo "Error: Please provide a path for the notebook."
    echo "Usage: $0 path/to/notebook.ipynb"
    exit 1
fi

# Create the directory structure.
mkdir -p "$(dirname "$1")"

# Create a new Jupyter notebook at the specified path.
echo '{
 "cells": [],
 "metadata": {},
 "nbformat": 4,
 "nbformat_minor": 5
}' > "$1"
