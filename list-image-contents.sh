#!/usr/bin/env bash

set -eo pipefail
BASE_DIR=$(dirname "$0")
source $BASE_DIR/.env

if [ -z ${1+x} ]; then
    echo "Provide the image as the first argument:"
    echo "  $0 registry/imagename"
    exit 1
fi

TAG=$1
echo "Listing contents of image $TAG"

IMAGE_HASH=$(docker build -q --no-cache --build-arg base="$BASE_IMAGE" --build-arg lib="$TAG" -f "$BASE_DIR/utils/test.Dockerfile" .)
docker run --rm -it $IMAGE_HASH || true
docker rmi $IMAGE_HASH || true
