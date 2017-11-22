# goaccess_docker_remote
Docker infrastructure to run GoAccess using log file from remote host

Based on [GoAccess](https://goaccess.io/)

##Requirements

 - [docker](https://docs.docker.com/engine/installation/) 
 - [docker-compose](https://docs.docker.com/compose/install/)
 - private SSH key which allows to connect to remote server and read log
 
##Installation

  - Clone git repo
  - Rename all *.env.sample files to corresponded *.env files and set configuration variables  
  - Rename file id_rsa.sample to id_rsa and copy SSH key into this file
  - Modify goaccess.conf file if necessary, by default GoAccess config is customized for Apache web log
  - Set up containers running "docker-compose up"
  - Open GoAccess report in browser http://0.0.0.0:80 (if you set up GoAccess container port to 80)
  
## Workflow 
  Docker compose will spin up 4 containers and 2 volumes: 
  
  - goaccess_log_follower: connects to remote host via SSH and tails remote 
  log file to local volume shared with goaccess_log_analyzer container
  - goaccess_log_analyzer: reads log file from shared volume and creates html report in real time on shared volume
  - goaccess_nginx: nginx server to access GoAccess report through http
  - goaccess_nginx_auth: nginx basic authorization proxy for nginx
  
## Deploy on remote server using docker-machine

Repository contains deployment scripts to run GoAccess on remote server. Tested with DigitalOcean docker machine

 - Rename file deployment/deployment.env.sample to deployment/deployment.env and set DOCKER_MACHINE_NAME to 
 docker machine where you want to deploy containers 
 - Run deployment/deploy.sh   