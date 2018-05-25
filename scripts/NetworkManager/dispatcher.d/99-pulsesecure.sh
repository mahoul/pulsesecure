#!/bin/sh

(

set -x

IF=$1
STATUS=$2

USER=kike
CONTAINER=pulsesecure

NEW_RESOLV=/tmp/$CONTAINER-resolv.conf
NEW_HOSTS=/tmp/$CONTAINER-hosts

getContainerInfo() {
  /bin/su $USER -c "docker exec $CONTAINER cat /etc/resolv.conf" > $NEW_RESOLV
  /bin/su $USER -c "docker exec $CONTAINER cat /etc/hosts" > $NEW_HOSTS
}

wait_for_tunnel_ip() {
  TUNNEL_IP=`/sbin/ip addr show $IF | /bin/awk '/inet / {print $2}' | /bin/awk -F '/' '{print $1}'`
  while [ -z "$TUNNEL_IP" ]; do
    sleep 3;
    TUNNEL_IP=`/sbin/ip addr show $IF | /bin/awk '/inet / {print $2}' | /bin/awk -F '/' '{print $1}'`
  done
}

backup_conf_files(){
  cp -f /etc/hosts /etc/hosts.pulsesecure
  cp -f /etc/resolv.conf /etc/resolv.conf.pulsesecure
}

restore_conf_files(){
  cp -f /etc/hosts.pulsesecure /etc/hosts
  cp -f /etc/resolv.conf.pulsesecure /etc/resolv.conf
}

dnsmasq_enabled_in_nm(){
  grep -q 'dns=dnsmasq' /etc/NetworkManager/NetworkManager.conf
}

if [ "$IF" = "tun0" ] && [ "$STATUS" = "up" ]; then
  wait_for_tunnel_ip
  getContainerInfo

  if ! dnsmasq_enabled_in_nm; then
    backup_conf_files
  
    cat $NEW_RESOLV > /etc/resolv.conf
    cat $NEW_HOSTS > /etc/hosts
  fi
  exit $?
fi


if [ "$IF" = "tun0" ] && [ "$STATUS" = "down" ]; then
  if ! dnsmasq_enabled_in_nm; then
    restore_conf_files
  fi
  exit $?
fi

) 2>&1 | tee /tmp/pulsesecure-$1.log

