#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

USERID=`id -u $USER`

# singularity version < 3.0:
singularity run \
    -B ${SCRIPTPATH}/HOME_DIR:/opt/xrootd \
    -B ${SCRIPTPATH}/CACHE:/opt/cache \
    xrootd-caching-proxy-testing.simg

#singularity exec \
#    -B ${SCRIPTPATH}/HOME_DIR:/opt/xrootd \
#    -B ${SCRIPTPATH}/CACHE:/opt/cache \
#    xrootd-caching-proxy-testing.simg\
#    /bin/bash

# singularity version >=3.0:
#singularity run \
#    -H /opt/xrootd \
#    -B ${SCRIPTPATH}/HOME_DIR:/opt/xrootd \
#    -B ${SCRIPTPATH}/CACHE:/opt/cache \
#    test-image.sif \
#    /bin/bash