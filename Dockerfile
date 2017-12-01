FROM debian:stretch
RUN apt-get update && apt-get install -y devscripts dpkg-dev make
