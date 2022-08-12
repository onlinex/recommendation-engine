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

#PARAM-PAM

- noone is allowed to push into the main branch
- changes to the main branch can only be introduced through a merge request
- merge request only goes through when the build/test pipeline have run successfully
- so push to dev -> 

#TODO
- Deployment pipline
- Webhook integration
- FLUX (seems to be the best), ArgoCD, Fleet
https://www.cncf.io/blog/2021/04/12/simplifying-multi-clusters-in-kubernetes/
- Cloudflare ensure routing to servers