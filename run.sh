#!/bin/bash
#SOURCE_DIR=$1
if [ "$1" = "" ]; then
	SOURCE_DIR=$(pwd)
else
	SOURCE_DIR=$1
fi
XAUTH=$HOME/.Xauthority
touch $XAUTH
echo $SOURCE_DIR
docker run -it --rm \
  -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $XAUTHORITY:/home/developer/.Xauthority \
  -v "$SOURCE_DIR"/:/data \
  -w /data mullinix/nvidia-opengl-anaconda3-spyder:from-singularity-recipe

