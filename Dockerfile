# Pulsesecure image based on CentOS 7 and 
# https://progger.ru/2016/12/editable-etchosts-and-etcresolv-conf-in-docker-container/
# hacks.
#
FROM centos:7
MAINTAINER Enrique Gil <mahoul@gmail.com>

# Install networking tools and PulseSecure Client
RUN \ 
  yum clean all && \
  yum upgrade -y && \
  yum install -y \
    iproute \
    net-tools \
    sysvinit-tools

ADD dist/ps-pulse-linux-9.0r2.1-b819-centos-rhel-64-bit-installer.rpm /tmp/rpms/
ADD dist/docker-entrypoint.sh /

RUN \
  yum localinstall -y /tmp/rpms/*.rpm && \
  /usr/local/pulse/PulseClient_x86_64.sh install_dependency_packages && \
  yum clean all && \
  rm -rf /var/cache/yum /tmp/rpms/ && \
  chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# forward logs to docker log collector 
RUN mkdir -p /root/.pulse_secure/pulse/ && \
  ln -sf /dev/stdout /root/.pulse_secure/pulse/pulsesvc.log

#  touch /root/.pulse_secure/pulse/pulsesvc.log && \

CMD [ "/usr/bin/env", "LD_LIBRARY_PATH=/usr/local/pulse:$LD_LIBRARY_PATH", "/usr/local/pulse/pulseUi" ]

