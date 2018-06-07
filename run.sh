#!/bin/bash -e

HTTPPID=""
finish(){
  echo "Exiting."
  kill $HTTPPID || echo HTTP server has already been shutdown
  docker-compose down
}
trap finish EXIT

initial=$(lsof -i -P -n | grep com.dock | wc -l | sed 's/ //g')

echo "Starting local HTTP server on port 8000"
env PORT=8000 node app.js &
HTTPPID=$!
echo "Starting containers..."
docker-compose up -d --build

# the sockets leak about 10 per second
sleep 5

final=$(lsof -i -P -n | grep com.dock | wc -l | sed 's/ //g')
count=$(expr "${final}" - "${initial}")
if [ "${count}" -gt 25 ]; then
  echo "During the test we consumed ${count} fds which looks like a leak"
  exit 1
fi
exit 0
