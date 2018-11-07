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


# build opensource environment on hibench-base

FROM hibench-base

USER root

#USER docker

#==============================
# HADOOP Installation
#==============================

# Change to correct version of hadoop
ENV HADOOP_VERSION_DETAIL=2.6.5

# environment variables for HADOOP
ENV HADOOP_HOME /usr/local/hadoop-${HADOOP_VERSION_DETAIL}
ENV HADOOP_PREFIX /usr/local/hadoop-${HADOOP_VERSION_DETAIL}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/

RUN export HADOOP_INSTALL=$HADOOP_HOME
RUN export PATH=$PATH:$HADOOP_INSTALL/bin
RUN export PATH=$PATH:$HADOOP_INSTALL/sbin
RUN export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
RUN export HADOOP_COMMON_HOME=$HADOOP_INSTALL
RUN export HADOOP_HDFS_HOME=$HADOOP_INSTALL
RUN export YARN_HOME=$HADOOP_INSTALL
RUN export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
RUN export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"

RUN wget http://apache.mirrors.lucidnetworks.net/hadoop/common/hadoop-${HADOOP_VERSION_DETAIL}/hadoop-${HADOOP_VERSION_DETAIL}.tar.gz
RUN tar xzf hadoop-*.tar.gz -C /usr/local/
RUN rm -f hadoop-*.tar.gz 


#==============================
# SPARK Installation
#==============================

# spark home environments
ENV SPARK_HOME /usr/local/spark-${SPARK_VERSION_DETAIL}
ENV SPARK_MASTER_IP localhost

# download spark
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION_DETAIL}-bin-hadoop${HADOOP_FOR_SPARK_VERSION}.tgz 
RUN tar xzf spark-*.tgz -C /usr/local
RUN mv /usr/local/spark-* ${SPARK_HOME}
RUN rm -f spark-*.tgz 

# Copy updated config files
COPY conf/core-site.xml ${HADOOP_CONF_DIR}/
COPY conf/hdfs-site.xml ${HADOOP_CONF_DIR}/
COPY conf/mapred-site.xml ${HADOOP_CONF_DIR}/
COPY conf/yarn-site.xml ${HADOOP_CONF_DIR}/
COPY scripts/hadoop-env.sh ${HADOOP_CONF_DIR}/
COPY scripts/restart_hadoop_spark.sh /usr/bin
COPY scripts/bigger-workload /home/bigger-workload 

COPY conf/hibench.conf.template  ${HIBENCH_HOME}/conf/
COPY conf/spark.conf.template  ${HIBENCH_HOME}/conf/
copy welcome /root/welcome

RUN chmod +x /root/welcome
RUN chmod +x /usr/bin/restart_hadoop_spark.sh
COPY scripts/runexample.sh /home/runexample.sh
COPY scripts/start.sh /root/HiBench/start.sh
RUN chmod +x /home/runexample.sh
RUN chmod +x /root/HiBench/start.sh
RUN apt-get update && apt-get install -y vim
RUN apt-get install -y htop

RUN mv /root/HiBench /home/HiBench

ENV SPARK_HOME /usr/local/spark-${SPARK_VERSION_DETAIL}
ENV HIBENCH_HOME /home/HiBench
COPY scripts/change-user /home/ 
COPY scripts/custom-workload /home/
RUN chmod +r /home/custom-workload
RUN chmod +x /home/change-user

RUN sed -i 's:rmr-hdfs $INPUT_HDFS:rmr-hdfs $INPUT_HDFS > /dev/null/:' $HIBENCH_HOME/bin/workloads/ml/kmeans/prepare/prepare.sh
RUN sed -i 's:rmr-hdfs $OUTPUT_HDFS:rmr-hdfs $OUTPUT_HDFS > /dev/null/:' $HIBENCH_HOME/bin/workloads/ml/kmeans/spark/run.sh

ENTRYPOINT clear &&  ./home/HiBench/start.sh && bash
#ENTRYPOINT clear && ./home/HiBench/start.sh  


