FROM ttbb/kafka-ui:nake

COPY docker-build /opt/kafka-ui/mate
COPY conf /opt/kafka-ui/conf
ENV KAFKA_UI_CONF_DIR=/opt/kafka-ui/conf
ENV spring.config.additional-location=$KAFKA_UI_CONF_DIR/config.yml

WORKDIR /opt/kafka-ui

CMD ["/usr/bin/dumb-init", "bash", "-vx","/opt/kafka-ui/mate/scripts/start.sh"]
