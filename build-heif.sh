#!/usr/bin/env bash

set -eo pipefail
source .env

VERSION=1.15.1

IMAGE_NAME=libheif:$VERSION-x64
DOCKERFILE=libheif.Dockerfile

DAV1D=${DOCKER_REGISTRY%/}/libdav1d:1.1.0-x64
RAV1E=${DOCKER_REGISTRY%/}/librav1e:0.6.3-x64
DE265=${DOCKER_REGISTRY%/}/libde265:1.0.11-x64

TAG=${DOCKER_REGISTRY%/}/$IMAGE_NAME
docker build --tag $TAG \
    --build-arg de265="$DE265" \
    --build-arg rav1e="$RAV1E" \
    --build-arg dav1d="$DAV1D" \
    --build-arg base=$BASE_IMAGE \
    --build-arg date=$BUILD_DATE \
    --build-arg version=$VERSION \
    -f $DOCKERFILE .
./list-image-contents.sh $TAG
./extract-image-contents.sh $TAG
