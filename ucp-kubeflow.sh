# Create a namespace for kubeflow deployment
NAMESPACE=kubeflow
USERNAME=admin
KF_ENV=default
kubectl create namespace ${NAMESPACE}

# Which version of Kubeflow to use
# For a list of releases refer to:
# https://github.com/kubeflow/kubeflow/releases
VERSION=v0.1.2

# Initialize a ksonnet app. Set the namespace for it's default environment.
APP_NAME=ucp-kubeflow
ks init ${APP_NAME}
cd ${APP_NAME}
ks env set ${KF_ENV} --namespace ${NAMESPACE}

# Install Kubeflow components
ks registry add kubeflow github.com/kubeflow/kubeflow/tree/${VERSION}/kubeflow

ks pkg install kubeflow/core@${VERSION}
ks pkg install kubeflow/tf-serving@${VERSION}
ks pkg install kubeflow/tf-job@${VERSION}

# Create templates for core components
ks generate kubeflow-core kubeflow-core

# If your cluster is running on Azure you will need to set the cloud parameter.
# If the cluster was created with AKS or ACS choose aks, it if was created
# with acs-engine, choose acsengine
# PLATFORM=<aks|acsengine>
# ks param set kubeflow-core cloud ${PLATFORM}

# Enable collection of anonymous usage metrics
# Skip this step if you don't want to enable collection.
# ks param set kubeflow-core reportUsage true
# ks param set kubeflow-core usageId $(uuidgen)

# Enable usage of NodePort for the services but it is not secure
ks param set kubeflow-core jupyterHubServiceType NodePort
ks param set kubeflow-core tfAmbassadorServiceType NodePort
ks param set kubeflow-core tfJobUiServiceType NodePort


# Deploy Kubeflow
ks apply default -c kubeflow-core
