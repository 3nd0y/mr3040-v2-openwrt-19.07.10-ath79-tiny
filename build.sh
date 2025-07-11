#!/bin/bash

# Clone repo
git clone https://github.com/3nd0y/mr3040.git
cd mr3040

# Build Docker image
docker build -t mr3040-builder .

# Jalankan container dan publish port 8080
docker run -it --rm -p 8080:8080 mr3040-builder
