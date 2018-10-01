#!/bin/bash

#modify etc/hosts file to avoid connection error
cp /etc/hosts /etc/hostsbak
sed -i 's/::1/#::1/' /etc/hostsbak
cat /etc/hostsbak > /etc/hosts
sed -i 's/2.6.4/2.6.5/' $HIBENCH_HOME/conf/hadoop.conf
rm -rf /etc/hostsbak
cat /home/bigger-workload >> $HIBENCH_HOME/conf/workloads/ml/kmeans.conf

# restart all services
printf ">>> Starting all services \n"
/usr/bin/restart_hadoop_spark.sh &> /dev/null

printf ">>> Done. \n\n"
#${HIBENCH_HOME}/bin/workloads/micro/wordcount/prepare/prepare.sh
#${HIBENCH_HOME}/bin/workloads/micro/wordcount/hadoop/run.sh
