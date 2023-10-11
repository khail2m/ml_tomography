#!/bin/sh 
source ./Env.sh

if [ $# -eq 0 ]; then
    echo "Docker Container: $PROJECT_NAME"
    echo "$0 [argument]"
    echo "  no argument: Help"
    echo "  images:      docker images (list images)"
    echo "  ps:          docker ps     (list containers)"
    echo "  stop:        docker stop $PROJECT_NAME (stop container)"
    echo "  rmi:         docker rmi  $PROJECT_NAME (remove image)"
    exit 0
fi

case $1 in
    images)
        docker images
        ;;
    ps)
        docker ps
        ;;
    stop)
        docker stop $PROJECT_NAME
        ;;
    rmi)
        docker rmi $PROJECT_NAME
        ;;
    *)
        echo ""
        echo "Error: Wrong argument"
        exit 1
        ;;
esac
