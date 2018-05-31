#!/bin/bash -e

HTTPPID=""
finish(){
  echo "Exiting."
  kill $HTTPPID
  docker-compose down
}
trap finish EXIT

echo "Starting local HTTP server on port 8000"
env PORT=8000 node app.js &
HTTPPID=$!
echo "Starting containers..."
docker-compose up -d --build

watch "lsof -i -P -n | grep com.dock | wc -l"
