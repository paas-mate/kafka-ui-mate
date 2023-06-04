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
JVM_OPT="${JVM_OPT} -Xlog:gc*=info,gc+phases=debug:${KAFKA_UI_HOME}/logs/gc.log:time,uptime:filecount=10,filesize=100M"

sed -i s/localhost:9092/${KAFKA_BOOTSTRAP_SERVER}/g ${KAFKA_UI_CONF_DIR}/config.yml

mkdir ${KAFKA_UI_HOME}/logs
java $AGENT_OPT $JAVA_OPT $JVM_OPT -jar ${KAFKA_UI_HOME}/kafka-ui-api.jar >> ${KAFKA_UI_HOME}/logs/stdout.log 2 >> ${KAFKA_UI_HOME}/logs/stderr.log
