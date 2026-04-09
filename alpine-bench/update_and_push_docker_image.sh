#!/bin/bash

docker build -t alpine-bench:latest .
docker image tag alpine-bench:latest odraghi/alpine-bench:latest
docker push odraghi/alpine-bench:latest
