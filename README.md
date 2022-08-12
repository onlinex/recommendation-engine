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

- Blue-Green deployment (0 downtime deployment)
- A/B testing - very frequent automated testing

- People work of features in their feature branch
- People create MR to dev branch. Invokes Pipleine (build & test), can run in manual
- Managers create MR from dev to Stage. Invokes Pipeline (build & test), can run in manual

- Stage has some new code now. (Build & test & deploy) to stage (manual)
- Create MR from Stage to Production (main). Main has some new code now. (Build & test & deploy) to production (manual)



- noone is allowed to push into the main branch
- changes to the main branch can only be introduced through a merge request
- merge request only goes through when the build/test pipeline have run successfully

#TODO
- Deployment pipline
- Webhook integration
- FLUX (seems to be the best), ArgoCD, Fleet
https://www.cncf.io/blog/2021/04/12/simplifying-multi-clusters-in-kubernetes/
- Cloudflare ensure routing to servers