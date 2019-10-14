#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

USERID=`id -u $USER`

docker run \
    --rm \
    -it \
    --user $(id -u):$(id -g) \
    -h Helios \
    -v /etc/passwd:/etc/passwd \
    -v ${SCRIPTPATH}/HOME_DIR:/opt/xrootd \
    -v ${SCRIPTPATH}/CACHE:/opt/cache \
    test-image

#docker run \
#    --rm \
#    -it \
#    --user $(id -u):$(id -g) \
#    -h Helios \
#    -v /etc/passwd:/etc/passwd \
#    -v ${SCRIPTPATH}/HOME_DIR:/opt/xrootd \
#    -v ${SCRIPTPATH}/CACHE:/opt/cache \
#    test-image \
#    /bin/bash