#!/bin/bash

cd /opt/mntcephutils/entry/

cp install.sh /opt/escheduler/
cp monitor-logger.sh /opt/escheduler/

cd /opt/escheduler/

./install.sh

if [ ${BD_ESCHEDULER_ROLE} = "worker-server" ]; then
    ./bin/escheduler-daemon.sh start logger-server
    ./monitor-logger.sh &
fi
./bin/escheduler-daemon.sh front $BD_ESCHEDULER_ROLE
