docker rm btech-jenkins || true
docker run --name btech-jenkins -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home -v /home/fernando/p/jenkins:/btech_jenkins btech-jenkins
