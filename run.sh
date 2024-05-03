#!/bin/sh

if [ ! -f ./Config/Config.json ]; then
    cp ./Config/DefaultConfig.json ./Config/Config.json
    echo "Created a Congig.json in the ./Config folder for you. Please edit it accordingly."
fi

if [ ! -f ./docker-compose.yaml ]; then
    cp ./docker-compose.sample.yaml ./docker-compose.yaml
    echo "Created a docker-compose.yaml in the current folder for you. Please fill in the needed parameters."
else
    docker-compose up -d
fi
