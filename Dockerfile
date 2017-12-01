FROM debian:stretch

USER root
RUN apt-get update && apt-get install -y devscripts dpkg-dev make sudo
RUN echo 'jenkins ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/jenkins
USER jenkins
