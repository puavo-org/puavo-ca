FROM debian:stretch

USER root
RUN apt-get update && apt-get install -y devscripts dpkg-dev make
USER jenkins
