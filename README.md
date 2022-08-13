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

# CI / CD

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

To connect to cluster user kubectl CLI, with file that specifies cluster access
kubectl --kubeconfig=k8s-1-23-9-do-0-fra1-1660326304303-kubeconfig.yaml "some command here"

#TODO
- Deployment pipline
- Webhook integration
- FLUX (seems to be the best), ArgoCD, Fleet
https://www.cncf.io/blog/2021/04/12/simplifying-multi-clusters-in-kubernetes/
- Cloudflare ensure routing to servers


# LOCAL MACHINE CONTRO

- install chocolatey (For windows)
- install kubectl
- install kubernetes-helm
- install flux

installing flux on kubernetes
flux --kubeconfig=k8s-1-23-9-do-0-fra1-1660326304303-kubeconfig.yaml bootstrap gitlab --owner=onlinex --repository=recommendation-engine --branch=main --token-auth