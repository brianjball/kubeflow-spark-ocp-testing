FROM registry.redhat.io/ubi8/python-312

ENV HADOOP_VERSION=3.4.1
ENV SPARK_VERSION=4.0.1
ENV SCALA_VERSION=2.12
ENV PY4J_VERSION=0.10.9.7

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop3

USER root

RUN yum install -y java-21-openjdk
RUN ln -s ${SPARK_HOME}/bin/spark-submit /usr/local/bin/spark-submit && \
    ln -s ${SPARK_HOME}/bin/spark-class /usr/local/bin/spark-class

RUN ls -ltr /opt/

COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

# Mount the custom workload into the image.
# Note that it will get copied to HOME (/opt/app-root/src) when the job starts, so that needs to be an emptyDir PVC to handle permissions.
COPY spark-examples_2.13-4.0.1.jar /opt/
RUN chmod 755 /opt/spark-examples_2.13-4.0.1.jar

USER 1001

# Port for Pyspark Executor
EXPOSE 20000
EXPOSE 4040

ENTRYPOINT [ "/opt/entrypoint.sh" ]
