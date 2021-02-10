ARG ELK_VERSION
FROM logstash:${ELK_VERSION}
ADD config/logstash.yml /usr/share/logstash/config/logstash.yml
ADD pipeline /usr/share/logstash/pipeline
