#!/bin/bash

cd /opt/escheduler/logs/

function start_logger {
    ../bin/escheduler-daemon.sh start logger-server
}

while [ 1 -eq 1 ]; 
do
    sleep 10
    if ! test -e escheduler-logger-server.pid; then
        start_logger
    else
        ps -p `cat escheduler-logger-server.pid`
        if [ $? -ne 0 ]; then
            rm -f escheduler-logger-server.pid
            start_logger
        fi
    fi
done
