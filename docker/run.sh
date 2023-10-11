#!/bin/sh 
source ./Env.sh

if [ $# -gt 0 ] && [ $1 == "-h" ]; then
    echo "Run Container: $PROJECT_NAME"
    echo "$0 [argument]"
    echo "  no argument: docker run (publish ports for jupyter & tensorboard)"
    echo "  x11:         docker run with X11 forwarding"
    exit 0
fi

echo "Starting docker image: $IMAGE_NAME:$IMAGE_TAG"
echo "  user in container: $USER_NAME (uid=$USER_ID, gid=$GROUP_ID)"
echo "  project directory: $WORKDIR"


if [ $DEVICE == "gpu" ]; then
    RUNTIME="--runtime nvidia"
else
    RUNTIME=""
fi


if [ $MOUNT == "root" ]; then
    MOUNT_VOLUME=" \
    --volume $PWD/..:$WORKDIR \
	--volume /work/SeismicData:/work/SeismicData 
    "
else
    MOUNT_VOLUME=" \
	--volume $PWD/../bin:$WORKDIR/bin \
	--volume $PWD/../data:$WORKDIR/data \
	--volume $PWD/../doc:$WORKDIR/doc \
	--volume $PWD/../results:$WORKDIR/results \
	--volume $PWD/../src:$WORKDIR/src \
	--volume /work/SeismicData:/work/SeismicData \
	"
fi


if [ $# == 0 ]; then
    OPT_NET=" \
        --publish $PORT_JUPYTER:8888 \
        --publish $PORT_TENSORBOARD:6006 \
        "
else
    case $1 in
        x11)
            OPT_NET=" \
              -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
              -v $HOME/.Xauthority:/home/$USER_NAME/.Xauthority \
              --env="DISPLAY" \
              --net=host \
              "
            ;;
        *)
            echo ""
            echo "Error: Wrong argument"
            exit 1
            ;;
    esac
fi

docker run $RUNTIME \
      --tty \
      --rm \
      --name $PROJECT_NAME \
      $MOUNT_VOLUME \
      $OPT_NET \
      --ipc=host \
      $IMAGE_NAME &

echo ""
sleep 1
echo "$ docker ps"
sleep 2
docker ps

