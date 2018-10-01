#!/bin/bash

/home/runexample.sh



cat /root/welcome





#read -p 'Press <ENTER> now to continue with demo, or type exit to leave demo and do your own configuration:  ' -i 'continue' -e stay

#if [ $stay == 'exit' ]
#then
#  exit
#  echo 'You can start the demo again by typing $HIBENCH_HOME/start.sh'
#  printf "\n"
#fi


run=0
printf "\nWelcome to the Spark demo!\n\n"

while true
do
run=$((run + 1)) # keep track of run number
#printf "Choose a workload to run. Options: wordcount, kmeans, terasort, pagerank\n"
printf 'Workload: kmeans' 
printf "\nConfiguration of kmeans (default is pre-populated)\n"
printf "Choose a workload size. Type large for 4 million samples, huge for 0.1 billion samples, gigantic for 0.2 billion samples, or biggest for 0.25 billion samples \n"
read -p 'Workload size:  ' -i 'gigantic' -e size

if [ $size == 'large' ]
then
  read -p 'Number of Spark executors:  ' -i '10' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '4' -e cores
  read -p 'Memory per executor:  ' -i '5g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory
elif [ $size == 'huge' ]
then
  read -p 'Number of Spark executors:  ' -i '20' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '6' -e cores
  read -p 'Memory per executor:  ' -i '12g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory

elif [ $size == 'gigantic' ]
then
  read -p 'Number of Spark executors:  ' -i '26' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '6' -e cores
  read -p 'Memory per executor:  ' -i '12g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory

elif [ $size == 'tiny' ]
then
  read -p 'Number of Spark executors:  ' -i '5' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '2' -e cores
  read -p 'Memory per executor:  ' -i '5g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory

elif [ $size == 'biggest' ] # custom workload that uses 280 GB of memory
then
  read -p 'Number of Spark executors:  ' -i '26' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '5' -e cores
  read -p 'Memory per executor:  ' -i '13g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory

else
  echo "Sorry, we didn't recognize this workload. Here is the default configuration for gigantic workload."
  read -p 'Number of Spark executors:  ' -i '26' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '6' -e cores
  read -p 'Memory per executor:  ' -i '12g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory
  size="gigantic" #set unknown workload 

fi



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

  printf "\nRunning prepare...\n"
  $HIBENCH_HOME/bin/workloads/ml/kmeans/prepare/prepare.sh
  printf "\nRunning kmeans...\n"
  $HIBENCH_HOME/bin/workloads/ml/kmeans/spark/run.sh

#fix the report format once!
if [ $run == 1 ]
then
sed -i 's/Type/Type    /' $HIBENCH_HOME/report/hibench.report
fi


printf "\n\nResults:\n"
cat $HIBENCH_HOME/report/hibench.report
printf "\n\n\n"

printf "Try this demo on your own configuration, by cloning https://github.com/NinaMaller/spark-hibench-demo.git, and running ./run-container (Docker is required to run the demo)"
#read -p 'Press <ENTER> now to do another demo run, or type exit to leave demo and do your own configuration:  ' -i 'continue' -e stay

#if [ $stay == 'exit' ]
#then
#  echo 'Thanks for using the demo. You can start the demo again by typing $HIBENCH_HOME/start.sh'
#  printf "\n"

#  exit
#fi

printf "\n\n"

done

