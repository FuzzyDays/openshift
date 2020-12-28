# FROM ubuntu:lates
#FROM maven:3.6.0-jdk-11-slim AS build
FROM maven:3.6.0-jdk-11-slim AS maven_build
MAINTAINER Pete McGilley pete@mcgilley.com

EXPOSE 60000
#ADD https://github.com/FuzzyDays/openshift /home/app
#ADD https://github.com/FuzzyDays/openshift/src /home/app/src
#ADD https://github.com/FuzzyDays/openshift/pom.xml /home/app
#COPY src /home/app/src
COPY pom.xfml /home/app
WORKDIR /home/app
RUN ls
RUN cat pom.xml
RUN mvn -X clean
#ENTRYPOINT ["tail", "-f", "/dev/null"]
RUN mvn clean verify -Dthreads=5 -Dloops=5 -Drampup=5 -Durl=192.168.0.90 -Dport=5000 -Dtestfile=test01.jmx
#RUN mvn clean verify -Dthreads=5 -Dloops=5 -Drampup=5 -Durl=192.168.0.90 -Dport=5000 -Dtestfile=test01.jmx 
#RUN apt-get -y update
#RUN apt-get -y upgrade
#RUN apt-get install -y build-essential
#ENTRYPOINT ["/docker-entrypoint.sh"]
