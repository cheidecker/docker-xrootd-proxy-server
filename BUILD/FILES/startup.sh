#!/bin/bash

# turn on bash's job control
set -m

# Start the 1st process and wait until done
/bin/bash /opt/defaults/update_voms_proxy.sh
EXITCODE=$?
if [[ $EXITCODE -ne 0  ]]; then
    echo "An Error happened while creating voms proxy: ERROR ${EXITCODE}"
    exit $EXITCODE
fi

# Start all xrootd services by scanning for configs in /opt/xrootd/configs/*.cf
FILES=/opt/xrootd/configs/*.cf
for CONFIGPATH in $FILES; do
    echo ${CONFIGPATH}
    CONFIGNAME=`basename -s .cf ${CONFIGPATH}`
    echo "Starting ${CONFIGNAME} config..."
    /bin/bash /opt/defaults/xrootd-daemon.sh -a start -c ${CONFIGPATH} -w /opt/xrootd/${CONFIGNAME}
    EXITCODE=$?
    if [[ $EXITCODE -ne 0  ]]; then
        break
    fi
done

# If an Error occurred, try to terminate all running xrootd services
if [[ $EXITCODE -ne 0  ]]; then
    for CONFIGPATH in $FILES; do
        CONFIGNAME=`basename -s .cf ${CONFIGPATH}`
        echo "Stopping ${CONFIGNAME} config..."
        /bin/bash /opt/defaults/xrootd-daemon.sh -a stop -c ${CONFIGPATH} -w /opt/xrootd/${CONFIGNAME}
    done
    exit $EXITCODE
fi

echo "Startup done, renewing VOMS proxy every 24h."

# Waiting 24h for VOMS proxy renewal
trap "exit" INT
while true; do
    sleep 86400
    EXITCODE=$?
    if [[ $EXITCODE -ne 0  ]]; then
        echo "An Error happened while sleeping: ERROR ${EXITCODE}"
        for CONFIGPATH in $FILES; do
            CONFIGNAME=`basename -s .cf ${CONFIGPATH}`
            echo "Stopping ${CONFIGNAME} config..."
            /bin/bash /opt/defaults/xrootd-daemon.sh -a stop -c ${CONFIGPATH} -w /opt/xrootd/${CONFIGNAME}
        done
        exit $EXITCODE
    fi
    echo "Renewing VOMS proxy"
    /bin/bash /opt/defaults/update_voms_proxy.sh
    EXITCODE=$?
    if [[ $EXITCODE -ne 0  ]]; then
        echo "An Error happened while renewing voms proxy: ERROR ${EXITCODE}"
        for CONFIGPATH in $FILES; do
            CONFIGNAME=`basename -s .cf ${CONFIGPATH}`
            echo "Stopping ${CONFIGNAME} config..."
            /bin/bash /opt/defaults/xrootd-daemon.sh -a stop -c ${CONFIGPATH} -w /opt/xrootd/${CONFIGNAME}
        done
        exit $EXITCODE
    fi
done



