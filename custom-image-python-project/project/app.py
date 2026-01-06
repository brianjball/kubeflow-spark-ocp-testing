from pyspark.sql import SparkSession
from mypackage.work_func import count_elements


def create_spark():
    """
    Create the Spark "Driver" that manages everything.
    
    When running in Spark Operator, master and resources are controlled by K8s.
    """
    print("*" * 70)
    print("Creating Spark session...")
    print("*" * 70)
    
    spark = SparkSession.builder \
        .appName("CustomPySparkJob") \
        .config("spark.python.worker.reuse", "false") \
        .config("spark.python.worker.faulthandler.enabled", "true") \
        .config("spark.sql.execution.pyspark.udf.faulthandler.enabled", "true") \
        .getOrCreate()

    # make it less chatty
    spark.sparkContext.setLogLevel("WARN")
    return spark


def main():
    spark = create_spark()
    print(count_elements(spark))


if __name__ == "__main__":
    main()
