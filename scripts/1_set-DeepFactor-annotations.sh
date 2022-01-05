#!/usr/bin/env bash
# Small script for DF 2.1 webhook to insert explicit variables for an app

# Source the default variable file
source DF.vars

# Add in the needed run token
if [[ -z "${DF_RUN_TOKEN}" ]]; then
   echo "Need DF_RUN_TOKEN variable set in environment" 1>&2
   exit 1
fi
sed -i "s|        df.k8-app.run.token/runtoken.*|        df.k8-app.run.token/runtoken: \"${DF_RUN_TOKEN}\"|" ../kubernetes-manifests/*yaml

# Change the name of the app
if [[ -z "${DF_APP_NAME}" ]]; then
   DF_APP_NAME="Bank of Anthos"
fi
sed -i "s|        df.k8-app.name.*|        df.k8-app.name: \"${DF_APP_NAME}\"|" ../kubernetes-manifests/*yaml

# Change the alert policy or delete for portal default
if [[ -z "${DF_POLICY}" ]]; then
   # Delete the policy entry if not set
   sed -i "/        df.k8-app.alert\/policy.*/d" ../kubernetes-manifests/*yaml
else 
   sed -i "s|        df.k8-app.alert/policy.*|        df.k8-app.alert/policy: \"${DF_POLICY}\"|" ../kubernetes-manifests/*yaml
fi

# Include an alert policy if set
if [[ -z "${DF_LSA}" ]]; then
   # Delete the policy entry if not set
   sed -i "/        df.k8-app.lsa.*/d" ../kubernetes-manifests/*yaml
else 
   sed -i "s|        df.k8-app.lsa.*|        df.k8-app.lsa: \"${DF_LSA}\"|" ../kubernetes-manifests/*yaml
fi


  
