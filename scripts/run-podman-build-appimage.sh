#!/bin/bash

set -xe

SCRIPT_DIR=$(dirname $(readlink -f ${0}))

CONTAINER_IMAGE_TAG=chiaki-bionic

# Create build image
cd ${SCRIPT_DIR}
podman build -t ${CONTAINER_IMAGE_TAG} . -f Dockerfile.bionic

# Build AppImage
cd ${SCRIPT_DIR}/..
podman run --rm \
	-v "$(pwd):/build/chiaki:rw,z" \
	-w "/build/chiaki" \
	--device /dev/fuse \
	--cap-add SYS_ADMIN \
	-t ${CONTAINER_IMAGE_TAG} \
	/bin/bash -c "scripts/build-appimage.sh /build/appdir"
