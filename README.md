Use this repo to quickly get started with HiBench to run a Spark workload.

To run, clone this repo and type
```
./run_container.sh
```

Optional:
Run GoTTY with more options 
First, create an isolated network:
```
docker network create isolated_nw --internal
```
run the GoTTY command:
```
gotty-dir/gotty --config gotty-dir/gotty.cfg --max-connection 5 docker run --net isolated_nw -it --rm docker-hibench-demo &> /gotty-log &
```
Followed by disown.
To stop GoTTY:
```
ps -ef | grep gotty
kill pid
```

Troubleshooting: if a workload does not complete, check the memory usage to see if you are out of memory. If you are, you want 
to move docker's default /var/lib/docker to another directory.
Open the file /etc/docker/daemon.json (or create if did not exists):
vi /etc/docker/daemon.json
Add the following lines:
```
{
    "data-root": "/docker-mnt",
    "storage-driver": "overlay"
}
```
where /docker-mnt is the mounted directory to the new disk.
Then restart the docker daemon:
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
Confirm the correct disk by running
```
docker info | grep 'Docker Root Dir'
```
