#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`

docker build -t xrootd-caching-proxy-test-image ${SCRIPTPATH}

docker images
