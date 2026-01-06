from mypackage.executor_func import double_list


def count_elements(spark):
    data = spark.sparkContext.parallelize([x for x in range(5000000)], 1000)
    return data.mapPartitions(double_list).count()
