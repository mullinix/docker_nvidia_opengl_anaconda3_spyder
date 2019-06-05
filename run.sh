#!/bin/bash
SOURCE_DIR=$1
XAUTH=$HOME/.Xauthority
touch $XAUTH
docker run -it --rm \
  -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $XAUTHORITY:/home/developer/.Xauthority \
  -v $SOURCE_DIR/:/data \
  -w /data mullinix/nvidia-opengl-anaconda3-spyder:from-singularity-recipe

