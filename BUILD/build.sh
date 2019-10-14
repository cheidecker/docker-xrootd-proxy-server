#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`

docker build -t test-image ${SCRIPTPATH}

docker images
