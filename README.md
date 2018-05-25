# Docker image to run Pulse Secure Client on CentOS

## Files 

- mahoul-pulsesecure.tar.gz
Exported container image.
```sh
# Uncompress and import image
gunzip -dc mahoul-pulsesecure.tar.gz | docker load

```
- dist/ps-pulse-linux-5.3r4.2-b639-centos-rhel-64-bit-installer.rpm
CentOS PulseSecure RPM

- dist/docker-entrypoint.sh
Entrypoint for hosts and resolv.conf patching.
- Dockerfile
Dockerfile to build image.

- scripts/NetworkManager/dispatcher.d/99-pulsesecure.sh
Script to patch hosts and resolv.conf when device tun0 is brought up
and acquires an IP address.
- scripts/run-psecure.sh
Script to run the image.

