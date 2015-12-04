/docker-gen -watch -notify "/restart.sh" /fluentd/fluentd.tmpl /fluentd/fluentd.conf &
/usr/local/bin/fluentd -c /fluentd/fluentd.conf
