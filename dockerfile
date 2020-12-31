
FROM openjdk-11-rhel7:latest
#FROM openjdk-app
#FROM maven:3.6.0-jdk-11-slim AS maven_build
#FROM ubuntu:latest
##FROM maven:3.6.0-jdk-11-slim AS build
MAINTAINER Pete McGilley pete@mcgilley.com

 # install rsync
    RUN yum update -y
    RUN yum install rsync xinetd -y
    # configure rsync
    #RUN chown -R 1001:1001 /root/
    #ADD ./rsyncd.conf /root/
    #RUN sed -i 's/disable[[:space:]]*=[[:space:]]*yes/disable = no/g' /etc/xinetd.d/rsync # enable rsync
    #RUN cp /root/rsyncd.conf /etc/rsyncd.conf
    #RUN /etc/rc.d/init.d/xinetd start
    #RUN chkconfig xinetd on
    
RUN apt-get update  -y
RUN apt-get install rsync  -y
RUN rsync --version    

EXPOSE 60000
#ADD https://github.com/FuzzyDays/openshift /home/app
#ADD https://github.com/FuzzyDays/openshift/src /home/app/src
#ADD https://github.com/FuzzyDays/openshift/pom.xml /home/app
#RUN ls
#RUN ls /tmp
#RUN ls /var/lib/jenkins/jobs/bob/workspace/source
#COPY src /home/app/src
#COPY pom.xml /home/app
WORKDIR /tmp
RUN curl -LJO https://github.com/FuzzyDays/openshift/archive/main.zip \
   && unzip openshift-main.zip
RUN ls
WORKDIR /home/app
#RUN mkdir src
RUN chown -R 1001:1001 /home/app
RUN cp -R /tmp/openshift-main/src /home/app
RUN cp /tmp/openshift-main/pom.xml /home/app 
WORKDIR /tmp
RUN rm -R *
WORKDIR /home/app
RUN ls -lR
#RUN mvn -X clean
#ENTRYPOINT ["tail", "-f", "/dev/null"]
RUN mvn clean verify -Dthreads=5 -Dloops=5 -Drampup=5 -Durl=www.redhat.com/en -Dport=443 -Dtestfile=test01.jmx
CMD ["sh", "-c", "tail -f /dev/null"]
#RUN mvn clean verify -Dthreads=5 -Dloops=5 -Drampup=5 -Durl=192.168.0.90 -Dport=5000 -Dtestfile=test01.jmx 
#RUN apt-get -y update
#RUN apt-get -y upgrade
#RUN apt-get install -y build-essential
#ENTRYPOINT ["/docker-entrypoint.sh"]
