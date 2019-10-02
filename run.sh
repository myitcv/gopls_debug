#!/usr/bin/env bash

set -e

stop() {
    echo "shutting down"
    ./docker-compose down
}

trap stop SIGTERM

cd opencensus-service
make docker-agent
cd ..
docker volume create gopls_config
tar -c *.yaml | docker run --rm -i -w /data -v gopls_config:/data golang:1.13.1 tar xf -
./docker-compose up &

pid=$!
wait "$pid"
