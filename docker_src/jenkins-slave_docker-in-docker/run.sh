docker run -d -i --name jenkins-jnlp-slave --init --restart always -v agent1-workdir:/home/jenkins/agent -v /var/run/docker.sock:/var/run/docker.sock  jenkins/jnlp-slave -url http://192.168.223.231:8080/ -workDir=/home/jenkins/agent e9342ddddfc400f4d7ab93de0f15ba3ef015e5925f4a889e7ed5ce20e59a5b35 DockerIGMSrv02
