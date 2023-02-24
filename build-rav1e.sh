#!/usr/bin/env bash

set -eo pipefail
source .env

VERSION=0.6.3

IMAGE_NAME=librav1e:$VERSION-x64
DOCKERFILE=librav1e.Dockerfile

TAG=${DOCKER_REGISTRY%/}/$IMAGE_NAME
docker build --tag $TAG --build-arg base="$BASE_IMAGE" --build-arg rustversion="$RUST_VERSION" --build-arg rustflags="$RUSTFLAGS" --build-arg date="$BUILD_DATE" --build-arg version="$VERSION" -f $DOCKERFILE .
./list-image-contents.sh $TAG
./extract-image-contents.sh $TAG
