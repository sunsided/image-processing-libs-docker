#!/usr/bin/env bash

set -eo pipefail
source .env

VERSION=1.1.0

IMAGE_NAME=libdav1d:$VERSION-x64
DOCKERFILE=libdav1d.Dockerfile

TAG=${DOCKER_REGISTRY%/}/$IMAGE_NAME
docker build --tag $TAG --build-arg base=$BASE_IMAGE --build-arg date=$BUILD_DATE --build-arg version=$VERSION -f $DOCKERFILE .
./list-image-contents.sh $TAG
./extract-image-contents.sh $TAG
