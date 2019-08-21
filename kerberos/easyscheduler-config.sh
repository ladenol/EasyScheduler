#!/bin/bash

HARBOR=10.19.248.12:30100
ES_UI_IMAGE=tools/dep-centos7-eschedulerui-1.0.4:0.8-ping
ES_BACKEND_IMAGE=tools/dep-centos7-escheduler-1.0.4:st-0.2

NAMESPACE=ping
PREFIX=pre1
ZK=pre1-zookeeper1:2181,pre1-zookeeper2:2181,pre1-zookeeper3:2181
MYSQL_SERVER=pre1-mysql
MYSQL_USERNAME=root
MYSQL_PASSWD=123456

DATA_STORAGE_SIZE=1Gi
WORKER_NUM=1
