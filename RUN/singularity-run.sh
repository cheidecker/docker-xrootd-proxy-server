#!/bin/bash

# get script path
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

# get user ID
USERID=`id -u $USER`

# get singularity major version
VERSION=`singularity --version`
MAJORVERSION=${VERSION:0:1}

if [ "$MAJORVERSION" -eq "3" ]; then
    echo "Starting image for singularity version 3"
    # singularity version >=3.0:
    singularity run \
        -H /opt/xrootd \
        -B ${SCRIPTPATH}/HOME_DIR:/opt/xrootd \
        -B ${SCRIPTPATH}/CACHE:/opt/cache \
        xrootd-caching-proxy-testing.sif

elif [ "$MAJORVERSION" -eq "2" ]; then
    echo "Starting image for singularity version 2"
    # singularity version < 3.0:
    singularity run \
        -B ${SCRIPTPATH}/HOME_DIR:/opt/xrootd \
        -B ${SCRIPTPATH}/CACHE:/opt/cache \
        xrootd-caching-proxy-testing.simg

else
    echo "Unknown singularity version, will not start image..."
fi

