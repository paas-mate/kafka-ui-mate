FROM ttbb/kafka-ui:nake

COPY docker-build /opt/kafka-ui/mate

WORKDIR /opt/kafka-ui

CMD ["/usr/bin/dumb-init", "bash", "-vx","/opt/kafka-ui/mate/scripts/start.sh"]
