#!/bin/bash



clear 
cat /root/welcome
printf ">>> Starting all services. Configuring your Docker container should take up to\none minute"

/home/runexample.sh


clear

cat /root/welcome







run=0
printf "Workload: kmeans\n"
read -p "Press <Enter> now to configure the workload" -i '   ' -e cont

while true
do


#read -p 'Press <ENTER> now to continue with demo, or type exit to leave demo and do your own configuration:  ' -i 'continue' -e stay

#if [ $stay == 'exit' ]
#then
#  exit
#  echo 'You can start the demo again by typing $HIBENCH_HOME/start.sh'
#  printf "\n"
#fi

run=$((run + 1)) # keep track of run number

while true # we want the user to enter correct workload name
do

#printf "Choose a workload size. Type large for 4 million samples, huge for 0.1 billion samples, gigantic for 0.2 billion samples, or biggest for 0.25 billion samples \n"
printf "\nChoose workload size (default is pre-populated):\n"
#printf "Desciprtion of what to type, how many samples and approximate population of memory at most, and runtime: \n"
printf "Below are the names of the workloads, followed by number of samples,\napproximate maximum memory usage, and runtime: \n"
printf "200m (200 million samples, 200GB, ~9 minutes)\n"
printf "250m (250 million samples, 300GB, ~17 minutes)\n"
printf "350m (350 million samples, 385GB, ~23 minutes)\n"
printf "500m (500 million samples, 500GB, ~50 minutes)\n\n"


read -p "Workload size:  " -i '200m' -e size
if [ $size == '200m' ] # recommended, gigantic size
then
  size="gigantic"
  read -p 'Number of Spark executors (MAX 64):  ' -i '26' -e spark_executors
  if [ $spark_executors -gt 64 ]
  then
    echo "Sorry. Maximum executors is 64. Using default value 26"
    spark_executors=26
  fi
  max_cores_per_executor=$((64/spark_executors))
  read -p "Number of cores per executor (MAX $max_cores_per_executor):  " -i '6' -e cores
  if [ $cores -gt $max_cores_per_executor ]
  then
    echo "Sorry. Maximum executors is $max_cores_per_executor. Using max value $max_cores_per_executor"
    #cores=$max_cores_per_executor
  fi
  memory_per_exec=$((600/$spark_executors ))
  read -p "Memory per executor (format: number followed by g. MAX is $memory_per_exec):  " -i '12g' -e executor_memory
  read -p "Driver memory (format: number followed by g. MAX is $memory_per_exec):  " -i '1g' -e driver_memory
  break

elif [ $size == 'tiny' ] #testing purposes
then
  read -p 'Number of Spark executors:  ' -i '5' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '2' -e cores
  read -p 'Memory per executor:  ' -i '5g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory
  break

elif [ $size == '250m' ] # custom workload that uses 280 GB of memory
then
  read -p 'Number of Spark executors:  ' -i '26' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '5' -e cores
  read -p 'Memory per executor:  ' -i '16g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory
  break

elif [ $size == '350m' ] # custom workload that uses 280 GB of memory
then
  read -p 'Number of Spark executors:  ' -i '30' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '5' -e cores
  read -p 'Memory per executor:  ' -i '15g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory
  break

elif [ $size == '500m' ] # custom workload that uses 280 GB of memory
then
  read -p 'Number of Spark executors:  ' -i '30' -e spark_executors
  read -p 'Number of cores per executor:  ' -i '5' -e cores
  read -p 'Memory per executor:  ' -i '25g' -e executor_memory
  read -p 'Driver memory:  ' -i '1g' -e driver_memory
  break

else
#user entered his own configuration
cp /home/custom-workload /home/custom-workload-$size
sizenum="$(echo $size | sed 's/m//' )" # extarct only the number
# check if we got a number!
re='^[0-9]+$'
if ! [[ $sizenum == $re ]] ; then # if it is
  sed -i "s/NUM/$sizenum/g" /home/custom-workload-$size
  cat /home/custom-workload-$size >> $HIBENCH_HOME/conf/workloads/ml/kmeans.conf
  # then, get the configuration parameters:
  read -p 'Number of Spark executors:  '  -e spark_executors
  read -p 'Number of cores per executor:  ' -e cores
  read -p 'Memory per executor:  ' -e executor_memory
  read -p 'Driver memory:  ' -e driver_memory

  break
fi
#else, it is not a number. Show error message and prompt again 
printf "\n\n"
printf "Sorry, we didn't recognize this workload size. Please try again.\n"
printf "Format for custom workload is number of samples followed by m"
printf "\n"

fi

done # if correct config, exit while true

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

container_id=$(cat /etc/hostname)
  printf "\n\n
Prepare job will run followed by the Spark job. When the Spark job is running,\nMonitor the memory by clicking on the Memory Usage button below and scrolling\ndown to the memory header. Your Docker container id is $container_id, monitor\nyour usage by finding the container id in the processes' table\n" 

  printf "\nRunning prepare...\n"
  $HIBENCH_HOME/bin/workloads/ml/kmeans/prepare/prepare.sh 2> /dev/null
printf "\nFinished running prepare.\n"
printf "As the Spark job is running, monitor the memory by looking at the\ncontainer on your left, showing htop. Examine the usage of the 64 cores,\nand the memory usage shown next to the mem header.\nTo see more detail and monitor your own usage, click on the memory usage\nbutton below. Your Docker container id is $container_id, find it in the\nprocesses' table.\n"

  printf "\nRunning kmeans...\n"
  $HIBENCH_HOME/bin/workloads/ml/kmeans/spark/run.sh 2>/dev/null

#fix the report format once!
if [ $run == 1 ]
then
#sed -i 's/Type/Type    /' $HIBENCH_HOME/report/hibench.report
echo "Type            Input_data_size     Duration(s)      Throughput(bytes/s)" >  $HIBENCH_HOME/report/myreport
fi

# get results:
# update variables:
input_data_size=$(cat $HIBENCH_HOME/report/hibench.report | grep Scala | awk '{print $4}')
duration=$(cat $HIBENCH_HOME/report/hibench.report | grep Scala | awk '{print $5}')
throughput=$(cat $HIBENCH_HOME/report/hibench.report | grep Scala | awk '{print $6}')
rm  $HIBENCH_HOME/report/hibench.report
echo "SparkKmeans $input_data_size $duration $throughput" | awk  '{ printf("%-16s%-20s%-17s%-19s\n", $1, $2, $3, $4) }' >>  $HIBENCH_HOME/report/myreport
printf "\n\nResults:\n"
cat $HIBENCH_HOME/report/myreport
printf "\n\n\n"

printf "Try this demo on your own machine. Clone https://github.com/NinaMaller/spark-hibench-demo.git, and run ./run-container (Docker is required to run the demo)\n"

#printf "\nDon't forget to scroll down to see a deailed configuration of the server, and check out the videos\n"
printf "\nInterested in finding out more? Contact us! Email optane@intel.com\n"

#printf "\nYou can also run the demo again with a different configuraion."

printf "\n\n"

read -p "Press <Enter> now to run the demo again" -i '   ' -e cont
printf "Workload: kmeans \n"
done

