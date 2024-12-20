# Base image : ubuntu version 22.04
FROM ubuntu:22.04

# Description
LABEL description ="Dockerfile to containerize the slick application"

# Update all packages
RUN apt-get -y update

# Install apache on ubuntu
RUN apt-get install apache2 -y

# Copy web app from local to the container 
COPY ./webapp/ /var/www/html

# Port on which the app should listen on
EXPOSE 80

# systemctl start apache2 and makes apache to run in the background
#ENTRYPOINT [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
ENTRYPOINT [ "/usr/sbin/apache2ctl"] 

# Run the container in the background (no exit)
 CMD [ "-D", "FOREGROUND" ]
