# project name without space, lower case for image name
PROJECT_NAME=ml_tomography_jo

# device: cpu or gpu
DEVICE=gpu

GPU_FROM=pkgpl/pkgpl_base:0.22.1-gpu-horovod0.22.1-su-rsf
CPU_FROM=pkgpl/pkgpl_base:0.20-cpu-horovod0.20.0-su-rsf

# docker image name
IMAGE_NAME=$PROJECT_NAME
IMAGE_TAG=latest

# user name in container
#USER_NAME=dockeruser
USER_NAME=`whoami`

# work directory name
PROJECT_DIR=$PROJECT_NAME
WORKDIR=/home/$USER_NAME/$PROJECT_DIR

# mount project 'root' or 'sub'directories (bin, data, doc, results, src) only
MOUNT=root
#MOUNT=sub

USER_ID=`id -u`
GROUP_ID=`id -g`

PORT_JUPYTER=8895
PORT_TENSORBOARD=6015

JUPYTER_PASSWORD="your_password"
