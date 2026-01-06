#FROM quay.io/modh/odh-minimal-notebook-container:v3-20250704-9251d2c
FROM registry.redhat.io/ubi8/python-312

ENV HADOOP_VERSION=3.4.1
ENV SPARK_VERSION=4.0.1
ENV SCALA_VERSION=2.12
ENV PY4J_VERSION=0.10.9.7

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop3

USER root

COPY build.sh /opt/
RUN chmod 755 /opt/build.sh
RUN /opt/build.sh
RUN rm /opt/build.sh
 
COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

# Mount the custom workload into the image.
# Note that it will get copied to HOME (/opt/app-root/src) when the job starts, so that needs to be an emptyDir PVC to handle permissions.
COPY project /opt/project
RUN chmod 755 -R /opt/project/

USER 1001

# Port for Pyspark Executor
EXPOSE 20000
EXPOSE 4040

ENTRYPOINT [ "/opt/entrypoint.sh" ]
