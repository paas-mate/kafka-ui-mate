#!/bin/bash

# memory option
if [ ! -n "$HEAP_MEM" ]; then
  HEAP_MEM="256M"
fi
if [ ! -n "$DIR_MEM" ]; then
  DIR_MEM="256M"
fi
# mem option
JVM_OPT="-Xmx${HEAP_MEM} -Xms${HEAP_MEM} -XX:MaxDirectMemorySize=${DIR_MEM}"
# gc option
if [ ! -n "${GC_THREADS}" ]; then
  GC_THREADS=1
fi
JVM_OPT="${JVM_OPT} -XX:+UseG1GC -XX:MaxGCPauseMillis=10 -XX:+ParallelRefProcEnabled -XX:+UnlockExperimentalVMOptions"
JVM_OPT="${JVM_OPT} -XX:+DoEscapeAnalysis -XX:ParallelGCThreads=${GC_THREADS} -XX:ConcGCThreads=${GC_THREADS}"
# gc log option
JVM_OPT="${JVM_OPT} -Xlog:gc*=info,gc+phases=debug:/opt/perf/logs/gc.log:time,uptime:filecount=10,filesize=100M"

# skywalking java agent option
if [ -n "${SW_AGENT_ENABLE}" ]; then
  if [ ! -n "${SW_SERVICE_NAME}" ]; then
    SW_SERVICE_NAME="perf-mq-consumer"
  fi
  if [ ! -n "${SW_COLLECTOR_URL}" ]; then
    SW_COLLECTOR_URL="localhost:11800"
  fi
  # ignore springmvc agent plugin
  rm -rf /opt/perf/skywalking-agent/plugins/apm-springmvc-annotation*
  AGENT_OPT="-javaagent:/opt/perf/skywalking-agent/skywalking-agent.jar -Dskywalking.agent.service_name=${SW_SERVICE_NAME} -Dskywalking.collector.backend_service=${SW_COLLECTOR_URL}"
fi

java $AGENT_OPT $JAVA_OPT $JVM_OPT -jar ${KAFKA_UI_HOME}/kafka-ui-api.jar >> /opt/perf/logs/stdout.log 2 >> /opt/perf/logs/stderr.log
