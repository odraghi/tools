#!/bin/bash

docker build -t ubuntu24:3 .

docker image tag ubuntu24:3 harbor.odraghi.com/ubuntu24:3
docker image tag ubuntu24:3 harbor.odraghi.com/ubuntu24:latest

docker push harbor.odraghi.com/ubuntu24:3
docker push harbor.odraghi.com/ubuntu24:latest
