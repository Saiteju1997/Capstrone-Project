#!/bin/bash
cd /inet
docker build -t $JOB_NAME.V1.$BUILD_ID .
docker tag $JOB_NAME.V1.$BUILD_ID steju480/$JOB_NAME.V1.$BUILD_ID
docker tag $JOB_NAME.V1.$BUILD_ID steju480/$JOB_NAME.V1:latest
docker push steju480/Docker_trail.V1.$BUILD_ID
docker push steju480/Docker_trail.V1:latest
docker rmi steju480/$JOB_NAME.V1.$BUILD_ID
docker rmi steju480/$JOB_NAME.V1:latest

