#!/bin/bash

source easyscheduler-config.sh

display_help() {
    echo
    echo "Usage: $0 create|delete"
    echo
}

create() {
    ennctl -n ${NAMESPACE} create app ${PREFIX}-escheduler
    
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-backend-data.yaml -a ${PREFIX}-escheduler
    for path in `ls -1 --color=never cephutils`
    do
        ennctl -n ${NAMESPACE} create configmap ${PREFIX}-easyscheduler-${path} --from-file=cephutils/${path}
    done
    ennctl -n ${NAMESPACE} create configmap ${PREFIX}-easyscheduler-sql --from-file=sql

    sleep 10
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-master-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-worker-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-worker-service.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-api-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-api-service.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-ui-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-ui-service.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} create -f  /tmp/escheduler-alert-deployment.yaml -a ${PREFIX}-escheduler
}

delete() {
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-alert-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-ui-service.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-ui-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-api-service.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-api-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-worker-service.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-worker-deployment.yaml -a ${PREFIX}-escheduler
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-master-deployment.yaml -a ${PREFIX}-escheduler

    ennctl -n ${NAMESPACE} delete configmap ${PREFIX}-easyscheduler-sql
    for path in `ls -1 --color=never cephutils`
    do
        ennctl -n ${NAMESPACE} delete  configmap ${PREFIX}-easyscheduler-${path}
    done
    ennctl -n ${NAMESPACE} delete -f  /tmp/escheduler-backend-data.yaml -a ${PREFIX}-escheduler

    ennctl -n ${NAMESPACE} delete app ${PREFIX}-escheduler
}

if [[ $# -lt 1 ]]; then
  display_help
  exit 1
fi
if [ $1 == "create" ] || [ $1 == "delete" ]; then
  createOrdelete=$1
fi

for file in `ls -1 --color=never escheduler-*yaml`
do
    rm -f /tmp/${file}
    cp ${file} /tmp/${file}
    sed -i "s|%HARBOR%|${HARBOR}|g" /tmp/${file}
    sed -i "s|%ES_UI_IMAGE%|${ES_UI_IMAGE}|g" /tmp/${file}
    sed -i "s|%NAMESPACE%|${NAMESPACE}|g" /tmp/${file}
    sed -i "s|%PREFIX%|${PREFIX}|g" /tmp/${file}
    sed -i "s|%ZK%|${ZK}|g" /tmp/${file}
    sed -i "s|%ES_BACKEND_IMAGE%|${ES_BACKEND_IMAGE}|g" /tmp/${file}
    sed -i "s|%MYSQL_SERVER%|${MYSQL_SERVER}|g" /tmp/${file}
    sed -i "s|%MYSQL_USERNAME%|${MYSQL_USERNAME}|g" /tmp/${file}
    sed -i "s|%MYSQL_PASSWD%|${MYSQL_PASSWD}|g" /tmp/${file}
    sed -i "s|%DATA_STORAGE_SIZE%|${DATA_STORAGE_SIZE}|g" /tmp/${file}
    sed -i "s|%WORKER_NUM%|${WORKER_NUM}|g" /tmp/${file}
done

if [ "x${createOrdelete}" = "xcreate" ]; then
    create
elif [ "x${createOrdelete}" = "xdelete" ]; then
    delete
else
    display_help
fi
