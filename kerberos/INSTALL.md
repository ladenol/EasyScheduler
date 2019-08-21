# 部署EasyScheduler

## 1.修改配置文件

修改easyscheduler-config.sh中的配置：

```shell
HARBOR=10.19.248.12:30100		#HARBOR地址
ES_UI_IMAGE=tools/dep-centos7-eschedulerui-1.0.4:0.8-ping		#前端pod的image
ES_BACKEND_IMAGE=tools/dep-centos7-escheduler-1.0.4:st-0.2	#后端pod的image

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
```

## 2.部署
执行命令
```shell
./easyscheduler-ctl.sh create
```

## 3.访问服务
先查看escheduler-ui的svc。然后，访问页面VIP:PORT。使用enncloud/enncloud登录。
EasyScheduler的使用方法可以查看[官方文档](https://analysys.github.io/easyscheduler_docs_cn/%E7%B3%BB%E7%BB%9F%E4%BD%BF%E7%94%A8%E6%89%8B%E5%86%8C.html?_blank "官方文档")。

## 4.删除服务
执行命令
```shell
./easyscheduler-ctl.sh delete
```
>删除服务后，会将所有数据一起删除。
