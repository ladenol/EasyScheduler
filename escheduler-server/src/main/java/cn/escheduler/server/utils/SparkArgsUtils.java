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
package cn.escheduler.server.utils;


import cn.escheduler.common.Constants;
import cn.escheduler.common.enums.ProgramType;
import cn.escheduler.common.task.spark.SparkParameters;
import org.apache.commons.lang.StringUtils;

import java.util.ArrayList;
import java.util.List;


/**
 *  spark args utils
 */
public class SparkArgsUtils {

    /**
     *  build args
     * @param param
     * @return
     */
    public static List<String> buildArgs(SparkParameters param) {

        System.out.println(param);
        List<String> args = new ArrayList<>();

        args.add(Constants.MASTER);
        args.add("spark://" + param.getMaster());

        if(param.getProgramType() !=null ){
            if(param.getProgramType()!=ProgramType.PYTHON){
                if (StringUtils.isNotEmpty(param.getMainClass())) {
                    args.add(Constants.CLASS);
                    args.add(param.getMainClass());
                }
            }
        }


        if (param.getDriverCores() != 0) {
            args.add(Constants.DRIVER_CORES);
            args.add(String.format("%d", param.getDriverCores()));
        }

        if (StringUtils.isNotEmpty(param.getDriverMemory())) {
            args.add(Constants.DRIVER_MEMORY);
            args.add(param.getDriverMemory());
        }

        if (param.getTotalExecutorCores() != 0) {
            args.add(Constants.TOTAL_EXECUTOR_CORES);
            args.add(String.format("%d", param.getTotalExecutorCores()));
        }

        if (param.getExecutorCores() != 0) {
            args.add(Constants.EXECUTOR_CORES);
            args.add(String.format("%d", param.getExecutorCores()));
        } else {
            args.add(Constants.EXECUTOR_CORES);
            args.add(String.format("%d", 1));
        }

        if (StringUtils.isNotEmpty(param.getExecutorMemory())) {
            args.add(Constants.EXECUTOR_MEMORY);
            args.add(param.getExecutorMemory());
        }

        // --files --conf --libjar ...
        if (StringUtils.isNotEmpty(param.getOthers())) {
            String others = param.getOthers();
            if(!others.contains("--queue")){
                if (StringUtils.isNotEmpty(param.getQueue())) {
                    args.add(Constants.SPARK_QUEUE);
                    args.add(param.getQueue());
                }
            }
            args.add(param.getOthers());
        }else if (StringUtils.isNotEmpty(param.getQueue())) {
            args.add(Constants.SPARK_QUEUE);
            args.add(param.getQueue());

        }

        if (param.getMainJar() != null) {
            args.add(param.getMainJar().getRes());
        }

        if (StringUtils.isNotEmpty(param.getMainArgs())) {
            args.add(param.getMainArgs());
        }

        return args;
    }

}
