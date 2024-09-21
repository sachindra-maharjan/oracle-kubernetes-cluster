#!/bin/bash

clusterName=${CLUSTER_NAME}
licenseKey=${NEW_RELIC_LICENSE_KEY}

hasError=0

if [[ -z ${clusterName} ]];then
    echo "Please set the environment variable CLUSTER_NAME for kubernetes cluster name."
    hasError=1
fi

if [[ -z ${licenseKey} ]];then
    echo "Please set the environment variable NEW_RELIC_LICENSE_KEY with valid license key."
    hasError=1
fi

if [[ ${hasError} == 1 ]];then
    exit 1
else 
    KSM_IMAGE_VERSION="v2.10.0" && helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle --set global.licenseKey=${licenseKey} --set global.cluster=${clusterName} --namespace=newrelic --set newrelic-infrastructure.privileged=true --set global.lowDataMode=true --set kube-state-metrics.image.tag=${KSM_IMAGE_VERSION} --set kube-state-metrics.enabled=true --set kubeEvents.enabled=true --set newrelic-prometheus-agent.enabled=true --set newrelic-prometheus-agent.lowDataMode=true --set newrelic-prometheus-agent.config.kubernetes.integrations_filter.enabled=false --set logging.enabled=true --set newrelic-logging.lowDataMode=true

    sed -i "s/<CLUSTER_NAME>/${clusterName}/g" values.yaml
    sed -i "s/<NEW_RELIC_LICENSE_KEY>/${licenseKey}/g" values.yaml

    helm repo add newrelic https://helm-charts.newrelic.com && helm repo update && kubectl create namespace newrelic ; helm upgrade --install newrelic-bundle newrelic/nri-bundle -n newrelic --values values.yaml
    echo 0
fi