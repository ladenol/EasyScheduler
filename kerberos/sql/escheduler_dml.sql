USE `escheduler`;
-- Records of t_escheduler_user,user : admin , password : escheduler123
INSERT INTO `t_escheduler_user` VALUES ('1', 'admin', '055a97b5fcd6d120372ad1976518f371', '0', 'zhangliye@encdata.cn', '15900532616', '0', now(), now(), NULL);
INSERT INTO `t_escheduler_alertgroup` VALUES (1, 'escheduler管理员告警组', '0', 'escheduler管理员告警组',now(), now());
INSERT INTO `t_escheduler_relation_user_alertgroup` VALUES ('1', '1', '1', now(), now());

-- Records of t_escheduler_queue,default queue name : default
INSERT INTO `t_escheduler_queue` VALUES ('1', 'default', 'default', now(), now());
INSERT INTO `t_escheduler_version` VALUES (1,'1.0.4');
