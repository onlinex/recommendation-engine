# recommendation-engine

# Components
- API endpoint
- Data QUEUE
- Jobs QUEUE
- Serving server
- ML model
- Vector DB
- OLAP database
- OLTP database
- Some frontend
- Metrics
- Datree.io
- https://www.hellomonday.com/

# CI / CD pipeline

![alt text](https://docs.gitlab.com/ee/ci/introduction/img/gitlab_workflow_example_11_9.png)

- Blue-Green deployment (0 downtime deployment)
- A/B testing - very frequent automated testing

- People work of features in their feature branch
- People create MR to dev branch. Invokes Pipleine (build & test), can run in manual
- Managers create MR from dev to Stage. Invokes Pipeline (build & test), can run in manual

- Stage has some new code now. (Build & test & deploy) to stage (manual)
- Create MR from Stage to Production (main). Main has some new code now. (Build & test & deploy) to production (manual)

- nobody is allowed to push into the main/stage branches
- changes to the main/stage branches can only be introduced through a merge request
- MR only goes through when the build/test pipeline have run successfully

# Docker

https://docs.docker.com/develop/develop-images/multistage-build/

- Need multi-stage build
- Run multiple "docker build location --target image_name" on docker file
- Results in multiple docker images for multiple services

# TODO
- Deployment pipline
- Webhook integration
- FLUX (seems to be the best), ArgoCD, Fleet
https://www.cncf.io/blog/2021/04/12/simplifying-multi-clusters-in-kubernetes/
- Cloudflare ensure routing to servers

# LOCAL MACHINE CONTROL

- install chocolatey (For windows)
- install kubectl (CLI for kubernetes)
- install docli (CLI for docker)
- install kubernetes-helm (CLI for apackage manager for kubernetes)
- install flux (CLI for CI/CD)
- isntall k9s (For looking into kubernetes cluster)

# Steps

https://thenewstack.io/tutorial-a-gitops-deployment-with-flux-on-digitalocean-kubernetes/
https://github.com/fluxcd/flux2-multi-tenancy
https://www.gitops.tech/
https://blog.gurock.com/implement-ab-testing-using-kubernetes/
https://docs.gitlab.com/ee/ci/introduction/
https://tanzu.vmware.com/developer/guides/prometheus-multicluster-monitoring/

## Connect GitHub repository to container registry

- Create a secret. Secrets are environment variables that are encrypted.
    - Settings > Secrets > New secret.
    - Create a new secret with the name DOCKER_HUB_USERNAME and your Docker ID (username) as value.
    - Create a new Personal Access Token (PAT). Docker Hub Settings -> Security -> New Access Token.
    - Add PAT as a secret with name DOCKER_HUB_ACCESS_TOKEN

- The pipeline saves the images to Docker Hub. Enable inline caching.

## Authenticate Digital Ocean CLI

- Authenticate with personal access token
    - doctl auth init --context <NAME>
- Show contexts
    - doctl auth list
- Switch context
    - doctl auth switch --context <NAME>
- Verify account
    - doctl account get

- Download cluster config.\
    Add cluster credentials to config file at ~/.kube/config\
    Set current context to "k8s-1-23-9-do-0-fra1-1660326304303"

    - doctl k8s clusters kubeconfig save k8s-1-23-9-do-0-fra1-1660326304303

## kubectl swith context (switch cluster)

Note: kubectl uses the default kubeconfig file, $HOME/.kube/config.
Otherwise use: kubectl --kubeconfig=k8s-kubeconfig.yaml "some command here"

- Show contexts
    - kubectl config get-contexts
- Switch between clusters
    - kubectl config use-context k8s-1-23-9-do-0-fra1-1660326304303

## Flux

- Check flux/cluster compatibility
    - flux check --pre

- Show cluster namespaces
    - kubectl get ns

- List all pods in the namespace
    - kubectl get pods

- List all kustomizations and their status
    - flux get kustomizations

- Set up security credentials. Add ssh deployment key to CI/CD provider (GitLab)
    - flux identity


installing flux on kubernetes
flux --kubeconfig=k8s-1-23-9-do-0-fra1-1660326304303-kubeconfig.yaml bootstrap gitlab --owner=onlinex --repository=recommendation-engine --branch=main --token-auth

kubectl get all -n flux-system

https://fluxcd.io/docs/cmd/flux_uninstall/


flux --kubeconfig=k8s-1-23-9-do-0-fra1-1660326304303-kubeconfig.yaml bootstrap gitlab --owner=onlinex --repository=recommendation-engine --branch=main path=./clusters/fra1 --tocken_auth

# Repository structure

- clusters dir contains the Flux configuration per cluster


# Something else here

rockylinux
k8slens
https://etcd.io/
https://helm.sh/
https://kubernetes.io/docs/concepts/workloads/controllers/
https://www.cncf.io/blog/2021/04/12/simplifying-multi-clusters-in-kubernetes/
https://docs.cilium.io/en/v1.9/concepts/clustermesh/

prometheus

There should be a script that can run everything at once. (On a new cluster)
And kill everything at once (Clean the cluster).
Each cluster should have namespaces: flux-system, prometheus (metrics), starboard (safety)
https://anaisurl.com/full-tutorial-getting-started-with-flux-cd/
https://www.youtube.com/watch?v=5u45lXmhgxA