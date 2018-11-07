# build environment on ubuntu14.04
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#=========================#
#  Operating System setup #
#=========================#
FROM ubuntu:14.04


#=========================#
#   General Dependencies  #
#                         #
#   python at least 2.6   #
#   jdk at least 6        #
#   scala at least 2.10   #
#=========================#
ENV PYTHON_VERSION                   2.7
ENV JDK_VERSION                      7
ENV MAVEN_VERSION                    3.0.5


#=========================#
#    Hadoop and Spark     #
#=========================#
ENV HADOOP_VERSION                   hadoop2
ENV HADOOP_VERSION_DETAIL            2.6.4
ENV SPARK_VERSION                    spark1.6
ENV SPARK_VERSION_DETAIL             1.6.2
ENV HADOOP_FOR_SPARK_VERSION         2.6


#=========================#
#    CDH distribution     #
#=========================#
# Make sure the CDH-distribution matches the versions of HADOOP and SPARK
# Please check http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cdh_vd_cdh_package_previous.html

ENV CDH_VERSION                      5



USER root

## add proxy config inside FIREWALL
#==============================
# System Basic Tools  Installation
#==============================

# install basic build environment
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y git wget curl man unzip vim-tiny bc 

# install ssh server
RUN \
  apt-get update && \  
  apt-get -y install openssh-server; mkdir -p /var/run/sshd; locale-gen en_US en_US.UTF-8

# passwordless ssh
RUN rm -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN rm -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
RUN echo "    StrictHostKeyChecking no                     " >> /etc/ssh/ssh_config
RUN echo "    UserKnownHostsFile=/dev/null                 " >> /etc/ssh/ssh_config



#==============================
# Python Installation
#==============================

# install python
RUN apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-dev

#==============================
# Java Installation
#==============================

# Install Java
RUN \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-${JDK_VERSION}-jdk

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin


#==============================
# Maven Installation
#==============================

# download maven
RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${MAVEN_VERSION}/apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN mv apache-maven-* /usr/local/apache-maven

# define environment variables for maven
ENV M2_HOME /usr/local/apache-maven
ENV PATH $PATH:/usr/local/apache-maven/bin
# copy local maven repository to docker image
#RUN rm -rf /root/.m2
#ADD .m2 /root/.m2


#==============================
# ADD HiBench to docker image
#==============================

ENV HIBENCH_HOME /root/HiBench

# download right version of HiBench
RUN wget https://github.com/intel-hadoop/HiBench/archive/HiBench-6.0.zip
RUN unzip HiBench-6.0.zip -d /root/
RUN mv /root/HiBench-HiBench-6.0 ${HIBENCH_HOME}
RUN rm -f HiBench-6.0.zip
COPY conf/spark.conf ${HIBENCH_HOME}/conf/
COPY conf/hadoop.conf ${HIBENCH_HOME}/conf/
COPY conf/hibench.conf ${HIBENCH_HOME}/conf/

# start building HiBench
RUN apt-get update && apt-get install -y thrift-compiler
RUN cd ${HIBENCH_HOME} && \
mvn clean package -Dspark=1.6 -Dscala=2.10

