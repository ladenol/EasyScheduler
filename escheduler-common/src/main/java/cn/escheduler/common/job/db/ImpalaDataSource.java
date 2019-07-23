/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package cn.escheduler.common.job.db;

import cn.escheduler.common.Constants;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import static cn.escheduler.common.utils.PropertyUtils.getBoolean;
import static cn.escheduler.common.utils.PropertyUtils.getString;

/**
 * data source of Impala
 */
public class ImpalaDataSource extends BaseDataSource {

  private static final Logger logger = LoggerFactory.getLogger(ImpalaDataSource.class);

  /**
   * gets the JDBC url for the data source connection
   * @return
   */
  @Override
  public String getJdbcUrl() {
    String address = getAddress();
    if (address.lastIndexOf("/") != (address.length() - 1)) {
      address += "/";
    }
    String jdbcUrl = address + getDatabase();
    // kerberos authentication
    if (getBoolean(Constants.HADOOP_SECURITY_AUTHENTICATION_STARTUP_STATE)){
      jdbcUrl += String.format(";AuthMech=1;KrbRealm=ENNCLOUD.COM;KrbHostFQDN=%s;KrbServiceName=root", getString(Constants.KRB_HOST_FQDN));
      logger.info("impala jdbc url is: " + jdbcUrl);
    }

    if (StringUtils.isNotEmpty(getOther())) {
      jdbcUrl += "?" + getOther();
    }
    return jdbcUrl;
  }

  /**
   * test whether the data source can be connected successfully
   * @throws Exception
   */
  @Override
  public void isConnectable() throws Exception {
    Connection con = null;
    try {
      Class.forName("com.cloudera.impala.jdbc41.Driver");
      con = DriverManager.getConnection(getJdbcUrl(), getUser(), getPassword());
    } finally {
      if (con != null) {
        try {
          con.close();
        } catch (SQLException e) {
          logger.error("Impala datasource try conn close conn error", e);
          throw e;
        }
      }
    }
  }

}
