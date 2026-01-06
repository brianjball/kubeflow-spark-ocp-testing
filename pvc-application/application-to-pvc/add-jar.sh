oc apply -f pvc.yaml
oc apply -f nginx.yaml
POD=$(oc get pods -o name | grep nginx | cut -d'/' -f2 | head -1)
oc rsync ./ $POD:/opt/jars/
oc delete -f nginx.yaml
