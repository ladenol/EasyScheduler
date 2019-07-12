#!/bin/bash

cd /opt/mntcephutils/entry/

cp install.sh /opt/escheduler/
cp monitor-logger.sh /opt/escheduler/
cp escheduler_env.sh /opt/escheduler/conf/env/.escheduler_env.sh

cd /opt/escheduler/

./install.sh

cp /opt/escheduler/conf/*-site.xml /opt/spark/conf/

if [ ${BD_ESCHEDULER_ROLE} = "worker-server" ]; then
    ./bin/escheduler-daemon.sh start logger-server
    ./monitor-logger.sh &
fi
./bin/escheduler-daemon.sh front $BD_ESCHEDULER_ROLE
