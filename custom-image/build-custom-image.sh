oc new-build --name my-custom-image --strategy docker --binary --context-dir . -n custom-spark-job
oc start-build my-custom-image --from-dir . --follow --no-cache -n custom-spark-job