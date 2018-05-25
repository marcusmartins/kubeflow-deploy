# Create a namespace for kubeflow deployment
NAMESPACE=kubeflow
USERNAME=admin
KF_ENV=default
kubectl create namespace ${NAMESPACE}

# Which version of Kubeflow to use
# For a list of releases refer to:
# https://github.com/kubeflow/kubeflow/releases
VERSION=v0.1.2

# Set the namespace for it's default environment.
APP_NAME=ucp-kubeflow
# ks init ${APP_NAME}
# cd ${APP_NAME}
ks env set ${KF_ENV} --namespace ${NAMESPACE}

# Enable usage of NodePort for the services but it is not secure
ks param set kubeflow-core jupyterHubServiceType NodePort
ks param set kubeflow-core tfAmbassadorServiceType NodePort
ks param set kubeflow-core tfJobUiServiceType NodePort

# Deploy Kubeflow
ks apply default -c kubeflow-core
