export HADOOP_VERSION=3.4.1
export SPARK_VERSION=4.0.1
export SCALA_VERSION=2.12
export PY4J_VERSION=0.10.9.7

curl -o /tmp/hadoop.tgz https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
curl -o /tmp/spark.tgz https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz
tar -xvzf /tmp/hadoop.tgz -C /opt/dependencies
tar -xvzf /tmp/spark.tgz -C /opt/dependencies
rm -f /tmp/hadoop.tgz && rm -f /tmp/spark.tgz
