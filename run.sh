#!/bin/bash -e

server="node-server"
finish(){
  echo "Exiting."
  docker kill "${server}" || echo server has already shutdown
  docker-compose down
}
trap finish EXIT

initial=$(lsof -i -P -n | grep com.dock | grep -v UDP | wc -l | sed 's/ //g')

docker pull node:alpine

echo "Starting local HTTP server on port 8000"
docker run --name "${server}" --rm -d -v $(pwd):/code -e PORT=8000 -p 8000:8000 node:alpine node /code/app.js

echo "Starting containers..."
docker-compose up -d --build

# the sockets leak about 10 per second
sleep 5

final=$(lsof -i -P -n | grep com.dock | grep -v UDP | wc -l | sed 's/ //g')
count=$(expr "${final}" - "${initial}")
echo "At the beginning we consumed ${initial} fds. At the end we consumed ${final}."
if [ "${count}" -gt 25 ]; then
  echo "During the test we consumed ${count} fds which looks like a leak"
  exit 1
fi
exit 0
