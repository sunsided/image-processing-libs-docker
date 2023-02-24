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

# Remove registry name.
IMAGE_NAME=${TAG#$DOCKER_REGISTRY}

# Replace colon with dash.
IMAGE_NAME=${IMAGE_NAME//:/-}
ARCHIVE_NAME=${IMAGE_NAME}.tar.gz

echo "Creating archive ${ARCHIVE_NAME} from image $TAG"

# Create a temporary directory with the image name as a folder in it, e.g.
#   /tmp/libheif-1.15.1-x64.NYrd9bFm/libheif-1.15.1-x64
TMPDIR=$(mktemp -d -t ${IMAGE_NAME}.XXXXXXXX)
OUTDIR=${TMPDIR}/${IMAGE_NAME}
mkdir -p $OUTDIR

# Extract the layers and untar them into the above directory.
# After extraction, bundle a new archive.
docker image save $TAG | \
    tar --extract --wildcards --to-stdout '*/layer.tar' | \
    tar --extract --directory=$OUTDIR --ignore-zeros --keep-newer-files && \
    tar --create --gzip --file=${ARCHIVE_NAME} --directory=$TMPDIR $IMAGE_NAME

rm -rf $TMPDIR
