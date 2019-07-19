#!/bin/bash

workDir=`dirname $0`
workDir=`cd ${workDir};pwd`

source ${workDir}/conf/config/run_config.conf
source ${workDir}/conf/config/install_config.conf

# alert配置
# 邮件协议
mailProtocol="SMTP"

# 邮件服务host
mailServerHost="smtp.163.com"

# 邮件服务端口
mailServerPort="994"

# 发送人
mailSender="mailforl@163.com"

# 发送人密码
mailPassword="xxxxxxxx"

# TLS邮件协议支持
starttlsEnable="false"

# SSL邮件协议支持
# 注意：默认开启的是SSL协议，TLS和SSL只能有一个处于true状态
sslEnable="true"

# resourcemanager HA配置，如果是单resourcemanager,这里为空即可
yarnHaIps="192.168.xx.xx,192.168.xx.xx"

# 如果是单 resourcemanager,只需要配置一个主机名称,如果是resourcemanager HA,则默认配置就好
singleYarnIp="ark1"

#下载路径
downloadPath="/opt/escheduler/data/download"

# 任务执行路径
execPath="/opt/escheduler/data/exec"

# xls下载路径
xlsFilePath="/opt/escheduler/data/xls"

# 资源文件的后缀
resSuffixs="txt,log,sh,conf,cfg,py,java,sql,hql,xml"

# zk 配置
# zk session 超时
zkSessionTimeout="300"

# zk 连接超时
zkConnectionTimeout="300"

# zk 重试间隔
zkRetrySleep="100"

# zk重试最大次数
zkRetryMaxtime="5"

# master 配置
# master执行线程最大数,流程实例的最大并行度
masterExecThreads="100"

# master任务执行线程最大数,每一个流程实例的最大并行度
masterExecTaskNum="20"

# master心跳间隔
masterHeartbeatInterval="10"

# master任务提交重试次数
masterTaskCommitRetryTimes="5"

# master任务提交重试时间间隔
masterTaskCommitInterval="100"

# master最大cpu平均负载,用来判断master是否还有执行能力
masterMaxCpuLoadAvg="10"

# master预留内存,用来判断master是否还有执行能力
masterReservedMemory="1"


# worker 配置
# worker执行线程
workerExecThreads="100"

# worker心跳间隔
workerHeartbeatInterval="10"

# worker一次抓取任务数
workerFetchTaskNum="3"

# worker最大cpu平均负载,用来判断worker是否还有执行能力,保持系统默认，默认为cpu核数的2倍，当负载达到2倍时，
#workerMaxCupLoadAvg="10"

# worker预留内存,用来判断master是否还有执行能力
workerReservedMemory="1"

# api 配置
# api session 超时
apiServerSessionTimeout="7200"

# spring 最大文件大小
springMaxFileSize="1024MB"

# spring 最大请求文件大小
springMaxRequestSize="1024MB"

# api 最大post请求大小
apiMaxHttpPostSize="5000000"

# kerberos 配置
# kerberos 是否启动
kerberosStartUp="true"

# kdc krb5 配置文件路径
krb5ConfPath="/etc/krb5.conf"

# keytab 用户名
keytabPrincipal="root/easyscheduler@ENNCLOUD.COM"

# 用户 keytab路径
keytabPath="/opt/mntcephutils/entry/easyscheduler.keytab"


# 1,替换文件
echo "1,替换文件"
sed -i "s#spring.datasource.url.*#spring.datasource.url=jdbc:mysql://${BD_MYSQL_SERVER}/escheduler?characterEncoding=UTF-8#g" conf/dao/data_source.properties
sed -i "s#spring.datasource.username.*#spring.datasource.username=${BD_MYSQL_USERNAME}#g" conf/dao/data_source.properties
sed -i "s#spring.datasource.password.*#spring.datasource.password=${BD_MYSQL_PASSWD}#g" conf/dao/data_source.properties

sed -i "s#org.quartz.dataSource.myDs.URL.*#org.quartz.dataSource.myDs.URL=jdbc:mysql://${BD_MYSQL_SERVER}/escheduler?characterEncoding=UTF-8#g" conf/quartz.properties
sed -i "s#org.quartz.dataSource.myDs.user.*#org.quartz.dataSource.myDs.user=${BD_MYSQL_USERNAME}#g" conf/quartz.properties
sed -i "s#org.quartz.dataSource.myDs.password.*#org.quartz.dataSource.myDs.password=${BD_MYSQL_PASSWD}#g" conf/quartz.properties

sed -i "s#yarn.resourcemanager.ha.rm.ids.*#yarn.resourcemanager.ha.rm.ids=${yarnHaIps}#g" conf/common/hadoop/hadoop.properties
sed -i "s#yarn.application.status.address.*#yarn.application.status.address=http://${singleYarnIp}:8088/ws/v1/cluster/apps/%s#g" conf/common/hadoop/hadoop.properties

sed -i "s#resource.view.suffixs.*#resource.view.suffixs=${resSuffixs}#g" conf/common/common.properties

sed -i "s#zookeeper.quorum.*#zookeeper.quorum=${BD_ZOOKEEPER_SERVERS}#g" conf/zookeeper.properties
sed -i "s#zookeeper.session.timeout.*#zookeeper.session.timeout=${zkSessionTimeout}#g" conf/zookeeper.properties
sed -i "s#zookeeper.connection.timeout.*#zookeeper.connection.timeout=${zkConnectionTimeout}#g" conf/zookeeper.properties
sed -i "s#zookeeper.retry.sleep.*#zookeeper.retry.sleep=${zkRetrySleep}#g" conf/zookeeper.properties
sed -i "s#zookeeper.retry.maxtime.*#zookeeper.retry.maxtime=${zkRetryMaxtime}#g" conf/zookeeper.properties

sed -i "s#master.exec.threads.*#master.exec.threads=${masterExecThreads}#g" conf/master.properties
sed -i "s#master.exec.task.number.*#master.exec.task.number=${masterExecTaskNum}#g" conf/master.properties
sed -i "s#master.heartbeat.interval.*#master.heartbeat.interval=${masterHeartbeatInterval}#g" conf/master.properties
sed -i "s#master.task.commit.retryTimes.*#master.task.commit.retryTimes=${masterTaskCommitRetryTimes}#g" conf/master.properties
sed -i "s#master.task.commit.interval.*#master.task.commit.interval=${masterTaskCommitInterval}#g" conf/master.properties
sed -i "s#master.max.cpuload.avg.*#master.max.cpuload.avg=${masterMaxCpuLoadAvg}#g" conf/master.properties
sed -i "s#master.reserved.memory.*#master.reserved.memory=${masterReservedMemory}#g" conf/master.properties

sed -i "s#worker.exec.threads.*#worker.exec.threads=${workerExecThreads}#g" conf/worker.properties
sed -i "s#worker.heartbeat.interval.*#worker.heartbeat.interval=${workerHeartbeatInterval}#g" conf/worker.properties
sed -i "s#worker.fetch.task.num.*#worker.fetch.task.num=${workerFetchTaskNum}#g" conf/worker.properties
sed -i "s#worker.max.cpuload.avg.*#worker.max.cpuload.avg=${workerMaxCupLoadAvg}#g" conf/worker.properties
sed -i "s#worker.reserved.memory.*#worker.reserved.memory=${workerReservedMemory}#g" conf/worker.properties

sed -i "s#server.session.timeout.*#server.session.timeout=${apiServerSessionTimeout}#g" conf/application.properties
sed -i "s#spring.http.multipart.max-file-size.*#spring.http.multipart.max-file-size=${springMaxFileSize}#g" conf/application.properties
sed -i "s#spring.http.multipart.max-request-size.*#spring.http.multipart.max-request-size=${springMaxRequestSize}#g" conf/application.properties
sed -i "s#server.max-http-post-size.*#server.max-http-post-size=${apiMaxHttpPostSize}#g" conf/application.properties

sed -i "s#mail.protocol.*#mail.protocol=${mailProtocol}#g" conf/alert.properties
sed -i "s#mail.server.host.*#mail.server.host=${mailServerHost}#g" conf/alert.properties
sed -i "s#mail.server.port.*#mail.server.port=${mailServerPort}#g" conf/alert.properties
sed -i "s#mail.sender.*#mail.sender=${mailSender}#g" conf/alert.properties
sed -i "s#mail.passwd.*#mail.passwd=${mailPassword}#g" conf/alert.properties
sed -i "s#mail.smtp.starttls.enable.*#mail.smtp.starttls.enable=${starttlsEnable}#g" conf/alert.properties
sed -i "s#mail.smtp.ssl.enable.*#mail.smtp.ssl.enable=${sslEnable}#g" conf/alert.properties

sed -i "s#ips.*#ips=${ips}#g" conf/config/install_config.conf

sed -i "s#masters.*#masters=${masters}#g" conf/config/run_config.conf
sed -i "s#workers.*#workers=${workers}#g" conf/config/run_config.conf
sed -i "s#alertServer.*#alertServer=${alertServer}#g" conf/config/run_config.conf
sed -i "s#apiServers.*#apiServers=${apiServers}#g" conf/config/run_config.conf

sed -i "s#%BD_ZOOKEEPER_SERVERS%#${HADOOP_ZOOKEEPER_SERVERS}#g" conf/core-site.xml
sed -i "s#%BD_SUITE_PREFIX%#${BD_SUITE_PREFIX}#g" conf/hdfs-site.xml
sed -i "s#%SERVICE_NAME_1%#${SERVICE_NAME_1}#g" conf/hdfs-site.xml
sed -i "s#%SERVICE_NAME_2%#${SERVICE_NAME_2}#g" conf/hdfs-site.xml
sed -i "s#%POSTFIX%#${POSTFIX}#g" conf/hdfs-site.xml
sed -i "s#%KDC_SERVICE%#${KDC_SERVICE}#g" /etc/krb5.conf

sed -i "s#hadoop.security.authentication.startup.state.*#hadoop.security.authentication.startup.state=${kerberosStartUp}#g" conf/common/common.properties
sed -i "s#java.security.krb5.conf.path.*#java.security.krb5.conf.path=${krb5ConfPath}#g" conf/common/common.properties
sed -i "s#login.user.keytab.principal.*#login.user.keytab.principal=${keytabPrincipal}#g" conf/common/common.properties
sed -i "s#login.user.keytab.path.*#login.user.keytab.path=${keytabPath}#g" conf/common/common.properties


# 2,创建目录
echo "2,创建目录"

# 如果downloadPath不存在,则创建
if ! test -e $downloadPath; then
  mkdir -p $downloadPath
fi

# 如果$execPath不存在,则创建
if ! test -e $execPath; then
  mkdir -p $execPath
fi

# 如果$xlsFilePath不存在,则创建
if ! test -e $xlsFilePath; then
  mkdir -p $xlsFilePath
fi
