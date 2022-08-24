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
- Linkerd service mesh
- Flagger
- https://www.hellomonday.com/

Building a sucessfull business
- Build in public, open source code.
- Provide value first, without the expecation of return.
- Target the market you care about.
- Offer your services for free.

# CI / CD pipeline

![alt text](https://docs.gitlab.com/ee/ci/introduction/img/gitlab_workflow_example_11_9.png)

https://codefresh.io/blog/enterprise-ci-cd-best-practices-part-1/

- All project assets are in source control
- A single artifact is produced for all environments
- Artifacts move within pipelines (and not source revisions)
- Development happens with short-lived branches (one per feature)
- Store your dependencies
- Tests are automated
- Security scanning is part of the process
- Quality scanning/Code reviews are part of the process

## Requirements

- A/B testing \
    Optionally test an update. \
    Divert 5-10% of traffic between "primary" and "canary". \
    Observe merics. \
    Rollback. \

- 0 Downtime deployment. \

- Deploy to canary. \
    - Contribute to main branch. \
    - Build new main:version image. \
    - FluxCD pull new image, route 10% traffic to canary. \

- Deploy to primary. \
    - Contribute to main branch with release tag. \
    - Build new main:release-version image. \
    - FluxCD pull new image, route traffic everywhere. \

- No staging environment, staging blocks production. \
- Test/Dev envioration and production environments' hardware should not mix. \

Tag as release v* -> deploy to primary. \

 

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

Set up full CI/CD. Unit tests, Python linting, builds, versioning, module versioning, etc. Get version from $VERSION variable.

- Free domain name
- API over https, Let's encrypt
- Cloudflare ensure routing to servers
- DB
- OAuth 2.0, token generation.
- Sample webapp, ingress route traffic.
- reCAPTCHA v3 (2018).
- Record events to redis streams.
- Save to DB.
- ML app. Event vectorizer + Ranker.
- Beautify.
- Redis cache, performance improvements.
- Service mesh.
- Simple admin panel.
- Design, logo, hellomonday.com, font. Please don't use blue. Everyone is using blue, it's boring. Blue = IBM / Intuit. It's old.
Best color pallete is green/wood http://admin.pixelstrap.com/viho/theme/index.html.

Colors:
black/white: professional, clean
green: nature, calm, good luck
orange: warm, autumn
brown: rustic, practical, warm, vintage

- Analytics.
- Better user experience.
- Low latency scale to 3 AZ.
- Cold Storage for user logs.

# LOCAL MACHINE CONTROL

- install chocolatey (For windows)
- install kubectl (CLI for kubernetes)
- install docli (CLI for docker)
- install kubernetes-helm (CLI for apackage manager for kubernetes)
- install flux (CLI for CI/CD)
- isntall k9s (For looking into kubernetes cluster)

# Cluster requirements

- 2 Nodes
    - 2vCPU, 2gb

# Steps

https://thenewstack.io/tutorial-a-gitops-deployment-with-flux-on-digitalocean-kubernetes/
https://github.com/fluxcd/flux2-multi-tenancy
https://www.gitops.tech/
https://blog.gurock.com/implement-ab-testing-using-kubernetes/
https://docs.gitlab.com/ee/ci/introduction/
https://tanzu.vmware.com/developer/guides/prometheus-multicluster-monitoring/
https://fluxcd.io/docs/guides/image-update/
https://squeaky.ai/blog/development/why-we-dont-use-a-staging-environment
https://devopswithkubernetes.com/part-4/3-gitops
https://github.com/containrrr/watchtower

## Connect GitHub repository to container registry (Docker Hub)

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

Kustomize allows declarative management of kubernetes.

- Check flux/cluster compatibility
    - flux check --pre

- Install flux on kubernetes
    The deploy key will be linked to the personal access token used to authenticate. \

    - flux bootstrap github \
      --owner=onlinex \
      --repository=recommendation-engine \
      --path=kubernetes/clusters/fra1 \
      --branch=main \
      --personal \
      --components-extra=image-reflector-controller,image-automation-controller \
      --read-write-key

    The image-reflector-controller scans image repositories.\
    The image-automation-controller updates YAML files based on the latest images scanned, and commits the changes to a given Git repository. \
      
    Flux GitOps agent is now running

## Add infrastructure components (Ingress)

- Add folder
    - cd kubernetes
    - mkdir infrastructure

- Add ingress YAML files
    - Each <cluster-name>/flux-system directory contains YAML artifiacts responsible for deploying Flux operator.
    - Each <cluster-name> directory contains Kustomization YAML file, pointing to infrastructure components.
    - Each <cluster-name> directory contains Kustomization YAML file, pointing to the apps components.
    
    - Apps directory contains information about the namespace, pod and service.
    - Infrastructure directory contains ingress controller.

## Flux checks

- List all kustomizations and their status
    - flux get kustomizations

- Manage image repositories (should only be in one cluster)
    - flux get image repository gateway
    - flux get image policy gateway

- Get messages from image container registry handlers
    - flux get images all --namespace=flux-system

- Manual reconciliation
    - flux reconcile kustomization flux-system --with-source

- Place policy marker
    - {"$imagepolicy": "policy-namespace:policy-name"}
    - {"$imagepolicy": "policy-namespace:policy-name:tag"}
    - {"$imagepolicy": "policy-namespace:policy-name:name"}
    \
    These markers are placed inline in the target YAML, as a comment.

## Kubectl checks

- Show cluster namespaces
    - kubectl get ns

- List all pods in the namespace ("default" is standard)
    - kubectl get pods --namespace="insert namespace here"

- List tracked repositories by flux
    - kubectl get gitrepositories --namespace=flux-system

- See the ReplicaSet created by Deployment
    - kubectl get rs --namespace=app

- Try (if validation fails)
    - kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

- Check controller
    - kubectl get pods --namspace=ingress-system

- Check running images
    - kubectl get pods --namespace=app -o jsonpath="{.items[*].spec.containers[*].image}"

## System

- Check cpu/memory \
    Requests are what the container is guaranteed to get. \
    Limits are the maximum value to be allocated. \
    - kubectl describe node

- Drain the cluster node (clear from pods) \
    - kubectl drain pool-00jd07iv2-7uxuv --delete-emptydir-data --ignore-daemonsets

## Add webhook (Trigger a cluster reconciliation every time a source changes)


installing flux on kubernetes
flux --kubeconfig=k8s-1-23-9-do-0-fra1-1660326304303-kubeconfig.yaml bootstrap gitlab --owner=onlinex --repository=recommendation-engine --branch=main --token-auth

kubectl get all -n flux-system

https://fluxcd.io/docs/cmd/flux_uninstall/


flux --kubeconfig=k8s-1-23-9-do-0-fra1-1660326304303-kubeconfig.yaml bootstrap gitlab --owner=onlinex --repository=recommendation-engine --branch=main path=./clusters/fra1 --tocken_auth

# Repository structure

kubernetes \
├── apps \
│   ├── base (initial configuration) \
│   ├── production (inherited from base) \
│   └── staging (inherited from base) \
├── infrastructure \
│   ├── \
│   ├── \
│   └── \
└── clusters \
    ├── nyc1 (New York) \
        ├── flux-system (stores manifests for the Flux components) \
    ├── fra1 (Frankfurt) \
    ├── lon1 (London) \
    ├── sgp1 (Singapore) \
    └── staging (Additional cluster located anywhere, for staging) \
\
Production clusters sync automatically with main branch. \
Staging cluster sync automatically with stage branch. \
Staging cluster also has integration testing pipeline. \

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