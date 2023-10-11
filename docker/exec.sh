#!/bin/sh 
source ./Env.sh

if [ $# -gt 0 ] && [ $1 == "-h" ]; then
    echo "Container: $PROJECT_NAME"
    echo "$0 [argument]"
    echo "  no argument: bash"
    echo "  lab:         jupyter lab"
    echo "  notebook:    jupyter notebook"
    echo "  smi:         nvidia-smi"
    echo "  su:          bash for root user"
    echo "  fg [cmd]:    run shell commands foreground and stop"
    echo "  bg [cmd]:    run shell commands background"
    exit 0
fi

EXEC="docker exec"
EXEC_FG="$EXEC -it $PROJECT_NAME"
EXEC_BG="$EXEC -d $PROJECT_NAME"

if [ $# == 0 ]; then
    $EXEC_FG bash --login
else
    case $1 in
        su)
            $EXEC -it -u 0 $PROJECT_NAME bash --login
            ;;
        lab|notebook)
            IP=`curl ifconfig.me`
            USER=`whoami`
            echo "http://localhost:$PORT_JUPYTER or http://127.0.0.1:$PORT_JUPYTER"
            echo "  for ssh tunneling: ssh -N -L $PORT_JUPYTER:localhost:$PORT_JUPYTER $USER@$IP"
            #echo "  password: $JUPYTER_PASSWORD"
            #$EXEC_BG jupyter $1 --no-browser --ip=0.0.0.0 --NotebookApp.token=$JUPYTER_PASSWORD
            $EXEC_BG $HOME/miniconda3/bin/jupyter $1 --no-browser --ip=0.0.0.0 --NotebookApp.token=$JUPYTER_PASSWORD
            ;;
        smi)
            $EXEC_FG nvidia-smi
            ;;
        fg)
            shift 1
            $EXEC_FG $@
            ;;
        bg)
            shift 1
            $EXEC_BG $@
            ;;
        *)
            echo "Wrong argument"
            exit 1
            ;;
    esac
fi
