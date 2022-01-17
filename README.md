# GCP-demo2
Example of a Terraform script integrated in a Jenkins pipeline (Google Cloud Provider)
Backup of a CloudSQL (MySQL) database, using Kubernetes cronjob

## Prerequisites
* Terraform installed
* Gcloud SKD installed
* GCP service account
* Jenkins (Terraform plugin installed)

It supports creating:
- Custom VPC "new-network"
- Custom subnetwork depending on the custom VPC (us-central1)
- Firewall rule under the custom VPC
- Cluster type: Zonal
  - Region: us-central1
  - Autoscaling: on
  - Instance Type: n1-standard-1
- Ghost deployment with 2 replicas
  - Ingress controller to expose deploy
- CloudSQL (MySQL) instance
  - Backup using Kubernetes cronjob

## Terraform and Jenkins integration using Github repo
- Install Terraform plugin in Jenkins
- Configure Terraform in Jenkins
- Add repository credential
- Add GCP secret key to access the project.
- Create a pipeline using Jenkinsfile

### Usage
- Everything will be run on Jenkins
- Jenkins will be able to apply and destroy.
- An action should be select (apply/destroy)
- Select the pipeline and then Build with parameters.
- Depending on the option selected Jenkins will run the terraform script and perform that action on the GCP project

### Files
+ `versions.tf`  defines Terraform version and google provider.
+ `variables.tf` defines Project id.
+ `provider.tf`  defines Kubernetes and helm provider, and generate token to start deploying. Depends on cluster.tf
+ `backend.tf`   Stores the state as an object in a configurable prefix in a pre-existing bucket 
+ `vpc.tf`      Creates a custome network and a custom subnetwork, sets firewall rules.
+ `cluster.tf`   Creates a cluster inside custom subnetwork. Depends on Network module
+ `ghost.tf`     Deploys Ghost with 2 replicas
+ `ingress.tf`   Exposes deployment. Collection of rules that allow inbound connections to reach the endpoints defined by a backend. Depends on ghost.tf
+ `CloudSQL.tf`  Creates a MySQL instance with a database and a user.
+ `SQLproxy.tf\ values.yaml`  Creates a SQLproxy deployment to access MySQL instance
+ `kms.tf`       Creates a secret key to use with SQLproxy
+ `Kronjob`      Creates a backup of the MySQL database using Dockerfile, run daily
+ `Dockerfile`   Docker file with mysql and gsutil commands installed.
+ `workloadid.tf`Creates a service account to be used to access MySQL instance.
