#!/bin/bash
#
# Service script for XRootD caching services
# ----------------------------------------

# Service instance name
INSTANCE="XRootD"

# XRootD config path
CONFIG="/opt/xrootd/config.cf"

# XRootD logging and administration directory
WORKDIR="/opt/xrootd"

ACTION=''

# Enable debug output
DEBUG='0'


# Get options from command line
while getopts 'a:c:w:d:' flag; do
    case "${flag}" in
        a) ACTION="${OPTARG}" ;;
        c) CONFIG="${OPTARG}" ;;
        w) WORKDIR="${OPTARG}" ;;
        d) DEBUG="${OPTARG}" ;;
        *) error "Unexpected option ${flag}" ;;
    esac
done

mkdir -p ${WORKDIR}

# Starting command for XRootD services
if [ $DEBUG -eq '0' ]; then
    XROOTD_COMMAND='nohup xrootd -c '$CONFIG' -l '${WORKDIR}'/xrootd.log -k 100m &'
    CMSD_COMMAND='nohup cmsd -c '$CONFIG' -l '${WORKDIR}'/cmsd.log -k 100m &'
else
    XROOTD_COMMAND='nohup xrootd -c '$CONFIG' -l '${WORKDIR}'/xrootd.log -k 100m -d '$EBUG' &'
    CMSD_COMMAND='nohup cmsd -c '$CONFIG' -l '${WORKDIR}'/cmsd.log -k 100m -d '$EBUG' &'
fi

# Check for running service processes
if [ -f ${WORKDIR}/xrootd.pid ] && [ -f ${WORKDIR}/cmsd.pid ]; then
    XROOTDPID=`cat ${WORKDIR}/xrootd.pid | head -1`
    CMSDPID=`cat ${WORKDIR}/cmsd.pid | head -1`
fi
if [ -z "${CMSDPID}" ]; then
    N_CMSDPID=0
else
    N_CMSDPID=`ps -e | grep -c ${CMSDPID}`
fi
if [ -z "${XROOTDPID}" ]; then
    N_XROOTDPID=0
else
    N_XROOTDPID=`ps -e | grep -c ${XROOTDPID}`
fi

case "$ACTION" in
    'start')
        if [ "${N_CMSDPID:-0}" -eq 1 ] && [ "${N_XROOTDPID:-0}" -eq 1 ]; then
            echo "Not starting $INSTANCE - instance already running with PID: [$XROOTDPID],[$CMSDPID]"
        else
            echo "Starting $INSTANCE"
            echo "Starting $INSTANCE" > ${WORKDIR}/service.log
            # cd ${XRD_INSTALLATION_PATH}
            nohup $XROOTD_COMMAND &>> ${WORKDIR}/service.log &
            XROOTDDPID=$!
            echo ${XROOTDDPID} > ${WORKDIR}/xrootd.pid
            sleep 2
            nohup $CMSD_COMMAND &>> ${WORKDIR}/service.log &
            CMSDPID=$!
            echo ${CMSDPID} > ${WORKDIR}/cmsd.pid
            # Check if started successfully
            sleep 2
            if [ -z "${CMSDPID}" ]; then
                N_CMSDPID=0
            else
                N_CMSDPID=`ps -e | grep -c ${CMSDPID}`
            fi
            if [ -z "${XROOTDPID}" ]; then
                N_XROOTDPID=0
            else
                N_XROOTDPID=`ps -e | grep -c ${XROOTDPID}`
            fi
            if [ "${N_CMSDPID:-0}" -ne 1 ] && [ "${N_XROOTDPID:-0}" -ne 1 ]; then
                echo "An Error occurred while starting the xrootd instance"
                exit 1
            fi
        fi
        ;;

    'stop')
        if [ "${N_CMSDPID:-0}" -eq 1 ] && [ "${N_XROOTDPID:-0}" -eq 1 ]; then
            echo "stopping $INSTANCE"
            echo "stopping $INSTANCE" >> ${WORKDIR}/service.log
            kill -15 $XROOTDPID
            kill -15 $CMSDPID
            rm -rf ${WORKDIR}/xrootd.pid
            rm -rf ${WORKDIR}/cmsd.pid
        else
            echo "Cannot stop $INSTANCE - no processes found!"
        fi
        ;;

    'restart')
        $0 -a stop -w ${WORKDIR} -c $CONFIG
        sleep 5
        $0 -a start -w ${WORKDIR} -c $CONFIG
        ;;

    'status')
        if [ "${N_CMSDPID:-0}" -eq 1 ] && [ "${N_XROOTDPID:-0}" -eq 1 ]; then
            echo "$INSTANCE running with PID: [$XROOTDPID], [$CMSDPID]"
        else
            echo "$INSTANCE not running. PID files invalid."
        fi
        ;;

    *)
        echo "usage: $0 {-a start | stop | restart | status -c <config> -w <work_dir> -d <debug_level> }"
        ;;

    esac

exit 0

