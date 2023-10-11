#!/bin/sh 

source ./Env.sh

if [ $# -gt 0 ] && [ $1 == "-h" ]; then
    echo "Build Container: $PROJECT_NAME"
    echo "$0 [argument]"
    echo "  no argument: docker build (for $DEVICE)"
    echo "  -nc:         docker build without cache"
    exit 0
fi

if [ $DEVICE == "gpu" ]; then
    DOCKERFROM=$GPU_FROM
else
    DOCKERFROM=$CPU_FROM
fi

if [ $# == 0 ]; then
    CACHE=""
else
    case $1 in
        -nc)
            CACHE="--no-cache"
            ;;
        *)
            echo ""
            echo "Error: Wrong argument"
            exit 1
            ;;
    esac
fi

echo "Building new docker image for '$USER_NAME' (uid=$USER_ID, gid=$GROUP_ID), device=$DEVICE"
echo "  image name: $IMAGE_NAME:$IMAGE_TAG"
echo "  project directory: $PROJECT_DIR"


docker build \
  --rm \
  $CACHE \
  --build-arg dockerfrom=$DOCKERFROM \
  --build-arg username=$USER_NAME \
  --build-arg uid=$USER_ID \
  --build-arg gid=$GROUP_ID \
  --build-arg project_dir=$PROJECT_DIR \
  --file Dockerfile \
  --tag $IMAGE_NAME:$IMAGE_TAG \
  ./

