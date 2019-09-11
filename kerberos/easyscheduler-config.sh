HARBOR=10.19.248.12:30100        #HARBOR地址
ES_UI_IMAGE=tools/dep-centos7-eschedulerui-1.0.4:0.8-ping        #前端pod的image
ES_BACKEND_IMAGE=tools/dep-centos7-escheduler-1.0.4:st-0.3    #后端pod的image

NAMESPACE=ping
#PREFIX下需要先部署hadoop(有名字为${PREFIX}-namenode1-XXXXXX的pod)
PREFIX=pre1
#zk和mysql配置
ZK=pre1-zookeeper1:2181,pre1-zookeeper2:2181,pre1-zookeeper3:2181
MYSQL_SERVER=pre1-mysql
MYSQL_USERNAME=root
MYSQL_PASSWD=123456

#后端存储大小
DATA_STORAGE_SIZE=1Gi
#worker数量
WORKER_NUM=1
