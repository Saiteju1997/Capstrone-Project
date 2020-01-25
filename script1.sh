#!/bin/bash
cd /inet
docker build -t $JOB_NAME.v1.$BUILD_ID .
docker tag $JOB_NAME.v1.$BUILD_ID steju480/$JOB_NAME.v1.$BUILD_ID
docker tag $JOB_NAME.v1.$BUILD_ID steju480/$JOB_NAME.v1:latest
docker push steju480/Docker_trail.v1.$BUILD_ID
docker push steju480/Docker_trail.v1:latest
docker rmi steju480/$JOB_NAME.v1.$BUILD_ID
docker rmi steju480/$JOB_NAME.v1:latest

