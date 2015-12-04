FROM kiyoto/fluentd:0.10.56-2.1.1
MAINTAINER kiyoto@treausure-data.com
RUN mkdir /fluentd
RUN apt-get update && apt-get install curl -y
COPY docker-gen /docker-gen
COPY run.sh /run.sh
RUN chmod +x /run.sh
COPY restart.sh /restart.sh
RUN chmod +x /restart.sh
VOLUME ["/fluentd"]
CMD /run.sh
#sudo docker run -d --name fluentd -v /var/lib/docker/containers:/var/lib/docker/containers -v /Containers-APP/fluentd/fluentd.conf:/etc/fluent/fluent.conf -v /var/log/fluentd:/var/log/fluentd kiyoto/docker-fluentd
#映射容器目录用于访问容器日志 映射fluentd目录用于模板变更，重启容器  映射log目录，用于将日志写到宿主机 映射socket用于docker-gen 访问所有容器
#sudo docker run -d --name fluentd -v /var/lib/docker/containers:/var/lib/docker/containers -v /Containers-APP/fluentd:/fluentd -v /var/log/fluentd:/var/log/fluentd -v /var/run/docker.sock:/var/run/docker.sock chengjt/docker-fluentd

