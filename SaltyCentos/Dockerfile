FROM centos:centos7
MAINTAINER Marko Milenkovic

USER root

RUN yum -y epel-release && yum -y salt-minion && yum clean all

VOLUME /srv

WORKDIR /srv
CMD ["/bin/bash"]
