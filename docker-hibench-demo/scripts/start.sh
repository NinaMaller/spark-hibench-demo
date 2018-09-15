#!/bin/bash

/root/runexample.sh

printf "\nWelcome to the Spark demo!\n\n"

while true
do
printf "Choose a workload to run. Options: wordcount, kmeans, terasort, pagerank\n"
read -p 'Workload:  ' -i 'wordcount' -e workload
printf "\nConfiguration of $workload (default is pre-populated)\n"
printf "Choose a workload size. Type small for 0.32 gb, large for 3.2 gb, huge for 32 gb, or gigantic for 320 gb\n"
read -p 'Workload size:  ' -i 'huge' -e size
read -p 'Number of Spark executors:  ' -i '15' -e spark_executors
read -p 'Number of cores per executor:  ' -i '4' -e cores
read -p 'Memory per executor:  ' -i '20g' -e executor_memory
read -p 'Driver memory:  ' -i '20g' -e driver_memory


#echo $spark_executors
# change configuration in config files
rm $HIBENCH_HOME/conf/hibench.conf
cp  $HIBENCH_HOME/conf/hibench.conf.template  $HIBENCH_HOME/conf/hibench.conf
sed -i "s/workload_size/$size/"  $HIBENCH_HOME/conf/hibench.conf

rm  $HIBENCH_HOME/conf/spark.conf
cp  $HIBENCH_HOME/conf/spark.conf.template  $HIBENCH_HOME/conf/spark.conf
sed -i "s/spark_executors/$spark_executors/"  $HIBENCH_HOME/conf/spark.conf
sed -i "s/num_cores/$cores/"  $HIBENCH_HOME/conf/spark.conf
sed -i "s/executor_memory/$executor_memory/"  $HIBENCH_HOME/conf/spark.conf
sed -i "s/driver_memory/$driver_memory/"  $HIBENCH_HOME/conf/spark.conf

# run the workload

if [ $workload == 'wordcount' ]
then
  printf "\nRunning prepare...\n"
  $HIBENCH_HOME/bin/workloads/micro/wordcount/prepare/prepare.sh
  printf "\nRunning $workload\n"
  $HIBENCH_HOME/bin/workloads/micro/wordcount/spark/run.sh

elif [ $workload == 'kmeans' ]
then
  printf "\nRunning prepare...\n"
  $HIBENCH_HOME/bin/workloads/micro/terasort/prepare/prepare.sh
  printf "\nRunning $workload\n"
  $HIBENCH_HOME/bin/workloads/micro/terasort/spark/run.sh

elif [ $workload == 'kmeans' ]
then
  printf "\nRunning prepare...\n"
  $HIBENCH_HOME/bin/workloads/ml/kmeans/prepare/prepare.sh
  printf "\nRunning $workload\n"
  $HIBENCH_HOME/bin/workloads/ml/kmeans/spark/run.sh

elif [ $workload == 'pagerank' ]
then
  printf "\nRunning prepare...\n"
  $HIBENCH_HOME/bin/workloads/websearch/pagerank/prepare/prepare.sh
  printf "\nRunning $workload\n"
  $HIBENCH_HOME/bin/workloads/websearch/pagerank/spark/run.sh
else
  printf "We don't have that workload. Please try again."
fi

#fix the report format
sed -i 's/Type/Type       /' $HIBENCH_HOME/report/hibench.report
printf "\n\nResults:\n"
cat $HIBENCH_HOME/report/hibench.report
printf "\n\n\n\n\n"

done

