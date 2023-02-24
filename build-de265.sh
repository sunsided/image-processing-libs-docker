#!/usr/bin/env bash

set -eo pipefail
source .env

VERSION=1.0.11

IMAGE_NAME=libde265:$VERSION-x64
DOCKERFILE=libde265.Dockerfile

TAG=${DOCKER_REGISTRY%/}/$IMAGE_NAME
docker build --tag $TAG --build-arg base=$BASE_IMAGE --build-arg date=$BUILD_DATE --build-arg version=$VERSION -f $DOCKERFILE .

./list-image-contents.sh $TAG
./extract-image-contents.sh $TAG
