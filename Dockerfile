FROM centos:latest as base

FROM base as builder

MAINTAINER JAAK-IT <hello@jaak-it.com>

ENV container docker

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y groupinstall "Development tools"; yum clean all

RUN yum -y install epel-release https://centos7.iuscommunity.org/ius-release.rpm && yum clean all

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -

RUN yum -y install wget && \
     yum -y install centos-release-scl && \
     yum -y install python36u python36u-libs python36u-devel python36u-pip && \
     yum -y install cronie && \
     yum -y install inotify-tools && \
     yum -y install cairo-devel libjpeg-turbo && \
     yum -y install unzip bzip2 && \
     yum -y install scl-utils && \
     yum -y install java-1.8.0-openjdk && \
     yum -y install nodejs; yum clean all

RUN easy_install-3.6 pip

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

