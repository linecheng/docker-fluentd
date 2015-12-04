# Docker-Fluentd: the Container to Log Other Containers' Logs

## What

By running this container with the following command, one can aggregate the logs of Docker containers running on the same host:

```
sudo docker run -d --name fluentd -v /var/lib/docker/containers:/var/lib/docker/containers -v /Containers-APP/fluentd:/fluentd -v /var/log/fluentd:/var/log/fluentd -v /var/run/docker.sock:/var/run/docker.sock chengjt/docker-fluentd
```

By default, the container logs are stored in /var/log/docker/yyyyMMdd.log inside this logging container. The data is buffered, so you may also see buffer files like /var/log/docker/20141114.b507c71e6fe540eab.log where "b507c71e6fe540eab" is a hash identifier. You can mount that container volume back to host. So you should add volume `/var/lib/docker/containers:/var/lib/docker/containers`

Since containers ID are changed when recreated, we should have a dyanmic `fluentd.conf`.

For this project ,
`fluentd.conf` is created by [docker-gen](https://github.com/jwilder/docker-gen) using `fluentd.tmpl`.

`docker-gen` will atach the containers,if the containers id has changed , `fluentd.conf` will recreated .

For change fluentd.tmpl easy, you should be  better  to add volume `/yourpath/fluentd:/fluentd` , fluentd.tmpl  is under fluentd directory.

`-v /var/log/fluentd:/var/log/fluentd` make logs to you host .
`/var/run/docker.sock:/var/run/docker.sock` tells `docker-gen` watching which docker daemon..






Also, by modifying `fluent.conf` and rebuilding the Docker image, you can stream up your logs to Elasticsearch, Amazon S3, MongoDB, Treasure Data, etc.

The output log looks exactly like Docker's JSON formatted logs, except each line also has the "container_id" field:

```
{"log":"Fri Nov 14 01:03:19 UTC 2014\r\n","stream":"stdout","container_id":"db18480728ed247a64bf6df49684cb246a38bbe11f14276d4c2bb84f56255ff4"}
```

## How

`docker-fluentd` uses [Fluentd](https://www.fluentd.org) inside to tail log files that are mounted on `/var/lib/docker/containers/<CONTAINER_ID>/<CONTAINER_ID>-json.log`. It uses the [tail input plugin](https://docs.fluentd.org/articles/in_tail) to tail JSON-formatted log files that each Docker container emits.

Then, Fluentd adds the "container_id" field using the [record reformer](https://github.com/sonots/fluent-plugin-record-reformer) before writing out to local files using the [file output plugin](https://docs.fluentd.org/articles/out_file).

Fluentd has [a lot of plugins](https://www.fluentd.org/plugins) and can probably support your data output destination. For example, if you want to output your logs to Elasticsearch instead of files, then, add the following lines to `Dockerfile`

```
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "--yes", "make", "libcurl4-gnutls-dev"]
RUN ["/usr/local/bin/gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri"]
```

right before "ENTRYPOINT". This installs the output plugin for Elasticsearch. Then, update `fluent.conf` as follows.


```

```

## What's Next?

- [Fluentd website](https://www.fluentd.org)
- [Fluentd's Repo](https://github.com/fluent/fluentd)
- [Kubernetes's Logging Pod](https://github.com/GoogleCloudPlatform/kubernetes/tree/master/contrib/logging)
