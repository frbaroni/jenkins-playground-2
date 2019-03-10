docker run --name btech-jenkins -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home btech-jenkins
