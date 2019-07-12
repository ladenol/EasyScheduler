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
package cn.escheduler.common.task.java;

import cn.escheduler.common.enums.ProgramType;
import cn.escheduler.common.process.ResourceInfo;
import cn.escheduler.common.task.AbstractParameters;

import java.util.List;
import java.util.stream.Collectors;

/**
 * java parameters
 */
public class JavaParameters extends AbstractParameters {

  /**
   * major jar
   */
  private ResourceInfo mainJar;

  /**
   * major class
   */
  private String mainClass;

  /**
   * arguments
   */
  private String mainArgs;

  /**
   * resource list
   */
  private List<ResourceInfo> resourceList;

  /**
   * jvm arguments
   */
  private String jvmArgs;

  public ResourceInfo getMainJar() {
    return mainJar;
  }

  public void setMainJar(ResourceInfo mainJar) {
    this.mainJar = mainJar;
  }

  public String getMainClass() {
    return mainClass;
  }

  public void setMainClass(String mainClass) {
    this.mainClass = mainClass;
  }

  public String getMainArgs() {
    return mainArgs;
  }

  public void setMainArgs(String mainArgs) {
    this.mainArgs = mainArgs;
  }

  public List<ResourceInfo> getResourceList() {
    return resourceList;
  }

  public void setResourceList(List<ResourceInfo> resourceList) {
    this.resourceList = resourceList;
  }

  public String getJvmArgs() {
    return jvmArgs;
  }

  public void setJvmArgs(String jvmArgs) {
    this.jvmArgs = jvmArgs;
  }

  @Override
  public boolean checkParameters() {
    return mainJar != null;
  }


  @Override
  public List<String> getResourceFilesList() {
    if(resourceList !=null ) {
      this.resourceList.add(mainJar);
      return resourceList.stream()
              .map(p -> p.getRes()).collect(Collectors.toList());
    }
    return null;
  }


}
