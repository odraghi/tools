#!/bin/bash

docker build -t alpine-bench:3 .

docker image tag alpine-bench:3 odraghi/alpine-bench:3
docker image tag alpine-bench:3 odraghi/alpine-bench:latest

docker push odraghi/alpine-bench:3
docker push odraghi/alpine-bench:latest
