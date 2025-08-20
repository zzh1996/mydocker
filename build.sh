#!/bin/bash

set -e

docker build --platform=linux/amd64,linux/arm64 -t zzh1996/mydocker .
docker push zzh1996/mydocker
