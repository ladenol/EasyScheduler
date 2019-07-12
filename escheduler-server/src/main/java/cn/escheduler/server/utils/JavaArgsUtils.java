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
import cn.escheduler.common.task.java.JavaParameters;
import org.apache.commons.lang.StringUtils;

import java.util.ArrayList;
import java.util.List;


/**
 *  java args utils
 */
public class JavaArgsUtils {

    /**
     *  build args
     * @param param
     * @return
     */
    public static List<String> buildArgs(JavaParameters param) {

        System.out.println(param);
        List<String> args = new ArrayList<>();

        // --files --conf --libjar ...
        if (StringUtils.isNotEmpty(param.getJvmArgs())) {
            args.add(param.getJvmArgs());
        }

        if (param.getMainJar() != null) {
            args.add("-jar");
            args.add(param.getMainJar().getRes());
        }

        if (StringUtils.isNotEmpty(param.getMainArgs())) {
            args.add(param.getMainArgs());
        }

        return args;
    }

}
