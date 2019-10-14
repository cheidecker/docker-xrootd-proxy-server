FROM centos:centos7
LABEL XRootD caching proxy server and dedicated manager
WORKDIR /root/

# Install prerequisites
RUN yum -y update && yum clean all
RUN yum -y install python3 python3-devel cmake git gcc-c++ zlib-devel openssl-devel make libuuid-devel && yum clean all
RUN yum -y install epel-release && yum clean all

# Install XRootD
ADD http://xrootd.org/binaries/xrootd-stable-slc7.repo /etc/yum.repos.d/xrootd-stable-slc7.repo
RUN yum -y install xrootd xrootd-client xrootd-devel xrootd-client-devel && yum clean all

# Install XRootD python bindings
RUN python3 -m pip install XRootD

# Get Grid certificates
ADD http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo /etc/yum.repos.d/EGI-trustanchors.repo
RUN yum -y install ca-policy-egi-core && yum clean all

# Install VOMS clients for creation of proxy certificates
RUN yum -y install voms-clients-cpp && yum clean all

# Install CMS VOMS settings
ADD http://linuxsoft.cern.ch/wlcg/wlcg-centos7.repo /etc/yum.repos.d/wlcg-centos7.repo
ADD http://linuxsoft.cern.ch/wlcg/RPM-GPG-KEY-wlcg /etc/pki/rpm-gpg/RPM-GPG-KEY-wlcg
RUN yum -y install wlcg-repo wlcg-voms-cms

# Creating XRootD server directories
RUN mkdir -p /opt/xrootd
WORKDIR /opt/xrootd
ENV HOME /opt/xrootd
RUN mkdir -p /opt/cache

# Install cronjob for renewing voms-proxies
# RUN yum -y install cronie

EXPOSE 1094

# Install wrapper scripts for starting all necessary deamons
COPY FILES/startup.sh /opt/defaults/startup.sh
COPY FILES/xrootd-daemon.sh /opt/defaults/xrootd-daemon.sh
COPY FILES/update_voms_proxy.sh /opt/defaults/update_voms_proxy.sh

CMD ["/bin/bash", "/opt/defaults/startup.sh"]
