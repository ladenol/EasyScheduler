#!/bin/bash

cd /opt/mntcephutils/entry/

cp install.sh /opt/escheduler/
cp monitor-logger.sh /opt/escheduler/
cp escheduler_env.sh /opt/escheduler/conf/env/.escheduler_env.sh
cp krb5.conf /etc/krb5.conf
cp escheduler-daemon.sh /opt/escheduler/bin/

cd /opt/escheduler/

./install.sh

if [ ! -f /opt/mntcephutils/entry/easyscheduler.keytab ]; then
  kadmin -p root/admin -w 1234 -q "addprinc -randkey root/easyscheduler@ENNCLOUD.COM"
  kadmin -p root/admin -w 1234 -q "xst -k /opt/mntcephutils/entry/easyscheduler.keytab root/easyscheduler@ENNCLOUD.COM"
fi

cp /opt/escheduler/conf/*-site.xml /opt/spark/conf/

if [ ${BD_ESCHEDULER_ROLE} = "worker-server" ]; then
    ./bin/escheduler-daemon.sh start logger-server
    ./monitor-logger.sh &
fi
./bin/escheduler-daemon.sh front $BD_ESCHEDULER_ROLE
