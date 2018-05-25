# Pulsesecure image based on CentOS 7 and 
# https://progger.ru/2016/12/editable-etchosts-and-etcresolv-conf-in-docker-container/
# hacks.
#
FROM centos:6
MAINTAINER Enrique Gil <mahoul@gmail.com>

#RUN mkdir -p /tmp/rpms 

ADD dist/ps-pulse-linux-5.3r4.2-b639-centos-rhel-64-bit-installer.rpm /tmp/rpms/
ADD dist/docker-entrypoint.sh /

#ps-pulse-linux-5.3r4.2-b639-centos-rhel-64-bit-installer.rpm && \

# Install firebird 
RUN \ 
  yum install -y net-tools iproute sysvinit-tools && \
  yum localinstall -y /tmp/rpms/*.rpm && \
  /usr/local/pulse/PulseClient_x86_64.sh install_dependency_packages && \
  yum clean all && \
  rm -rf /var/cache/yum /tmp/rpms/ && \
  chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# forward logs to docker log collector 
RUN mkdir -p /root/.pulse_secure/pulse/ && \
  touch /root/.pulse_secure/pulse/pulsesvc.log && \
  ln -sf /dev/stdout /root/.pulse_secure/pulse/pulsesvc.log

#CMD [ "/usr/bin/supervisord", "-n" ]
CMD [ "/usr/bin/env", "LD_LIBRARY_PATH=/usr/local/pulse:$LD_LIBRARY_PATH", "/usr/local/pulse/pulseUi" ]
