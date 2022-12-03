# Docker file for building image with httpd and tomcat in start mode and one index.html file customized in our httpd
FROM ubuntu:latest
WORKDIR /root/nabajyoti
LABEL webserver="httpd"
LABEL appserver="tomcat"
MAINTAINER Nabajyoti Modak
# ARG [variable=value]; Here we don't need
RUN apt-get -y update &&\
apt-get -y upgrade
RUN apt-get -y install httpd
RUN sudo service start -y httpd
COPY /root/naba/index.html /var/www/html
RUN mkdir /usr/local/tomcat
RUN wget http://tomcat.9.0.62  
#RUN tar -xvzf apache-tomcat-9.0.62.tar.gz
#COPY /root/nabajyoti/apache-tomcat-9.0.62/* /usr/local/tomcat
ADD /root/nabajyoti/apache-tomcat-9.0.62.tar.gz /usr/local/tomcat
RUN chmod +x usr/local/tomcat/apache-tomcat-9.0.62/bin/sh
# ENV [username=admin, key=value]; Here it's not needed
ENTRYPOINT usr/local/tomcat/apache-tomcat-9.0.62/bin/sh
CMD startup.sh run
# If we want to avoid the entry point, we can give the CMD as
#CMD usr/local/tomcat/apache-tomcat-9.0.62/bin/startup.sh run
EXPOSE 8080





# Docker file for Nginx and copying a index.html file to nginx && Installing Jboss and runing of Jboss
FROM Alpine
WORKDIR /root/naba
LABEL webserver="nginx"
LABEL appserver="Jboss"
MAINTAINER Nabajyoti Modak
RUN apk -y update &&\                                                   # apk update                &&\
apk -y add nginx                                                        # apk add nginx (to install nginx)
RUN service start -y nginx                                              # service nginx start (to start nginx)
COPY /root/naba/index.html /usr/share/nginx/html
RUN mkdir /opt/Jboss &&\
cd /opt/Jboss
RUN wget https://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
RUN tar -xvzf jboss-as-7.1.1.Final.zip
RUN chmod +x opt/jboss/jboss-as-7.1.1.Final/bin/sh
ENTRYPOINT [ "opt/jboss/jboss-as-7.1.1.Final/bin/sh" ]
CMD [ "run.sh run" ]
EXPOSE 8080:9900




# Docker File for python App

FROM ubuntu-slim-buster As base
WORKDIR /root/naba/app
LABEL app="python"
LABEL Type="appserver"
LABEL App-file-name="app.py"
MAINTAINER Nabajyoti Modak
RUN apt-get update -y &&\
apt-get -y install sudo
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
ARG Version=3.8                                  # if needed
RUN apt-get install python -y                    # FROM python:3.8-slim-buster

FROM ubuntu-slim-buster As build
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

FROM build As stage
RUN cd /opt/Jboss
RUN wget https://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
RUN tar -xvzf jboss-as-7.1.1.Final.zip
RUN chmod +x opt/jboss/jboss-as-7.1.1.Final/bin/sh

FROM base As final
ENTRYPOINT [ "opt/jboss/jboss-as-7.1.1.Final/bin/run.sh run" ]
COPY /root/appserver/app.py server/default/deploy 
# Use ADD id the file is in zipped or tar format
CMD [ "python3", "-m" , "flask", "run" ]
EXPOSE 9090





# Dockerfile for Java Application

FROM openjdk:16-alpine3.13 As base-image
WORKDIR /root/naba/app
RUN apk -y add maven
COPY mvnw pom.xml ./

FROM openjdk:16-alpine3.13 As build-stage
RUN ./mvnw dependency:go-offline
RUN git clone https://git_repository/naba-app.git
ENTRYPOINT [ "./mwnv" ]

FROM build As stage-1
RUN cd /opt/Jboss
RUN wget https://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
RUN tar -xvzf jboss-as-7.1.1.Final.zip
RUN chmod +x opt/jboss/jboss-as-7.1.1.Final/bin/sh

FROM base As final-build
ENTRYPOINT [ "opt/jboss/jboss-as-7.1.1.Final/bin/run.sh run" ]
RUN mv *.war /app.war
COPY /root/appserver/app.war server/default/deploy 
CMD [ "spring-boot:run" ]
EXPOSE 9091
