FROM ttbb/kafka-ui:nake

COPY scripts /opt/kafka-ui/mate/scripts

WORKDIR /opt/kafka-ui

CMD ["/usr/bin/dumb-init", "bash", "-vx","/opt/kafka-ui/mate/scripts/start.sh"]
