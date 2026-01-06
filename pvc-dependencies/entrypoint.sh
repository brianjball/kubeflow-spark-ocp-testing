#!/bin/bash
set -eo pipefail

export JAVA_HOME=$(readlink -nf $(which java) | xargs dirname | xargs dirname) && \
    export HADOOP_HOME=$HADOOP_HOME && \
    export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop && \
    export SPARK_HOME=$SPARK_HOME && \
    export PYSPARK_PYTHON=python && \
    export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-$PY4J_VERSION-src.zip && \
    export SPARK_DIST_CLASSPATH=$SPARK_HOME/assembly/target/$SCALA_VERSION/jars/* && \
    export PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$PATH

if [ -z "$JAVA_HOME" ]; then
  JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | awk '{print $3}')
fi

SPARK_CLASSPATH="$SPARK_CLASSPATH:${SPARK_HOME}/jars/*"
for v in "${!SPARK_JAVA_OPT_@}"; do
    SPARK_EXECUTOR_JAVA_OPTS+=( "${!v}" )
done

if [ -n "$SPARK_EXTRA_CLASSPATH" ]; then
  SPARK_CLASSPATH="$SPARK_CLASSPATH:$SPARK_EXTRA_CLASSPATH"
fi

if ! [ -z "${PYSPARK_PYTHON+x}" ]; then
    export PYSPARK_PYTHON
fi
if ! [ -z "${PYSPARK_DRIVER_PYTHON+x}" ]; then
    export PYSPARK_DRIVER_PYTHON
fi

if ! [ -z "${HADOOP_CONF_DIR+x}" ]; then
  SPARK_CLASSPATH="$HADOOP_CONF_DIR:$SPARK_CLASSPATH";
fi

if ! [ -z "${SPARK_CONF_DIR+x}" ]; then
  SPARK_CLASSPATH="$SPARK_CONF_DIR:$SPARK_CLASSPATH";
elif ! [ -z "${SPARK_HOME+x}" ]; then
  SPARK_CLASSPATH="$SPARK_HOME/conf:$SPARK_CLASSPATH";
fi

# SPARK-43540: add current working directory into executor classpath
SPARK_CLASSPATH="$SPARK_CLASSPATH:$PWD"

case "$1" in
  driver)
    shift 1
    echo "Running the driver"
    echo $@
    $SPARK_HOME/bin/spark-submit \
      --conf "spark.driver.bindAddress=$SPARK_DRIVER_BIND_ADDRESS" \
      --conf "spark.executorEnv.SPARK_DRIVER_POD_IP=$SPARK_DRIVER_BIND_ADDRESS" \
      --deploy-mode client \
      "$@"
    ;;
  executor)
    shift 1
    ${JAVA_HOME}/bin/java \
      "${SPARK_EXECUTOR_JAVA_OPTS[@]}" \
      -Xms"$SPARK_EXECUTOR_MEMORY" \
      -Xmx"$SPARK_EXECUTOR_MEMORY" \
      -cp "$SPARK_CLASSPATH:$SPARK_DIST_CLASSPATH" \
      org.apache.spark.scheduler.cluster.k8s.KubernetesExecutorBackend \
      --driver-url "$SPARK_DRIVER_URL" \
      --executor-id "$SPARK_EXECUTOR_ID" \
      --cores "$SPARK_EXECUTOR_CORES" \
      --app-id "$SPARK_APPLICATION_ID" \
      --hostname "$SPARK_EXECUTOR_POD_IP" \
      --resourceProfileId "$SPARK_RESOURCE_PROFILE_ID" \
      --podName "$SPARK_EXECUTOR_POD_NAME"
    ;;

  *)
    # Non-spark-on-k8s command provided, proceeding in pass-through mode...
    exec "$@"
    ;;
esac