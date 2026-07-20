#!/bin/bash

docker login registry.redhat.io 


docker build -t ose-cli-custom:4 .
docker image tag ose-cli-custom:4 odraghi/ose-cli-custom:4
docker image tag ose-cli-custom:4 odraghi/ose-cli-custom:latest

docker push odraghi/ose-cli-custom:4
docker push odraghi/ose-cli-custom:latest
