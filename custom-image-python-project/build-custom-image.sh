oc new-build --name my-custom-python-image --strategy docker --binary --context-dir . -n custom-spark-job
oc start-build my-custom-python-image --from-dir . --follow --no-cache -n custom-spark-job