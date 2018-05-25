# Docker image to run Pulse Secure Client on CentOS



## Files 

- scripts/NetworkManager/dispatcher.d/99-pulsesecure.sh
Script to patch hosts and resolv.conf when device tun0 is brought up
and acquires an IP address.
- scripts/run-psecure.sh
Script to run the image.

## Quick and dirty build and run

```sh
$ cd pulsesecure
$ docker build -t $USER/pulsesecure .
$ sudo cp scripts/NetworkManager/dispatcher.d/99-pulsesecure.sh /etc/NetworkManager/dispatcher.d/
$ sudo systemctl restart NetworkManager
$ [ ! -d ~/bin ] && mkdir ~/bin
$ cp scripts/run-psecure.sh ~/bin && chmod +x ~/bin/run-psecure.sh
$ run-psecure.sh
```

