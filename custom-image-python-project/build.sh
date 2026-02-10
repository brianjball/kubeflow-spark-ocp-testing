yum install -y java-21-openjdk
curl -o /tmp/hadoop.tgz https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
curl -o /tmp/spark.tgz https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz
tar -xvzf /tmp/hadoop.tgz -C /opt
tar -xvzf /tmp/spark.tgz -C /opt
rm -f /tmp/hadoop.tgz && rm -f /tmp/spark.tgz
ln -s ${HADOOP_HOME} /opt/hadoop
ln -s ${SPARK_HOME} /opt/spark

rm -f /usr/local/bin/spark-submit /usr/local/bin/spark-class && \
    ln -s ${SPARK_HOME}/bin/spark-submit /usr/local/bin/spark-submit && \
    ln -s ${SPARK_HOME}/bin/spark-class /usr/local/bin/spark-class

echo "export JAVA_HOME=$(alternatives --display java | grep ' link currently points to ' | sed 's| link currently points to ||g' | sed 's|/bin/java$||g')" >> /etc/profile && \
    echo "export HADOOP_HOME=$HADOOP_HOME" >> /etc/profile && \
    echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /etc/profile && \
    echo "export SPARK_HOME=$SPARK_HOME" >> /etc/profile && \
    echo "export PYSPARK_PYTHON=python" >> /etc/profile && \
    echo "export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-$PY4J_VERSION-src.zip" >> /etc/profile && \
    echo "export SPARK_DIST_CLASSPATH=$SPARK_HOME/assembly/target/$SCALA_VERSION/jars/*" >> /etc/profile && \
    echo "export PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$PATH" >> /etc/profile
    echo "export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH" >> /etc/profile

export JAVA_HOME=$(readlink -nf $(which java) | xargs dirname | xargs dirname) && \
    export HADOOP_HOME=$HADOOP_HOME && \
    export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop && \
    export SPARK_HOME=$SPARK_HOME && \
    export PYSPARK_PYTHON=python && \
    export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-$PY4J_VERSION-src.zip && \
    export SPARK_DIST_CLASSPATH=$SPARK_HOME/assembly/target/$SCALA_VERSION/jars/* && \
    export PATH=$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$PATH && \
    export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

pip install pyspark==$SPARK_VERSION
