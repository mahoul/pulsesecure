# Docker image to run Pulse Secure Client on CentOS



## Files

- __dist__  
  Required files to build the image.
- __build-and-install.sh__  
  Quick and dirty build and install script.  
- __bin/run-psecure.sh__  
  Run script to launch the docker container.
- __local/share/icons/Pulse-Secure128x128.png__  
  Icon extracted from the container.
- __local/share/applications/pulse-docker.desktop__  
  Desktop file extracted from the container and tweaked to run run-psecure.sh
- __etc/NetworkManager/conf.d/dns.conf__  
  NetworkManager.conf override to enable dnsmasq dns plugin.  
- __etc/NetworkManager/dispatcher.d/99-pulsesecure.sh__  
  Dispatcher script to backup resolv.conf and hosts file before connection is brought
  up, and to restore the files when the connection is brought down.  
  Has no use if _dnsmasq_ plugin is enabled in _NetworkManager_.

## Quick and dirty build and install

```sh
$ cd pulsesecure
$ docker build -t $USER/pulsesecure .
$ find bin/ etc/ -iname "*.sh" -exec chmod +x {} \;
$ sudo rsync -avP etc/NetworkManager/ /etc/NetworkManager/
$ sudo systemctl restart NetworkManager
$ [ ! -d ~/bin ] && mkdir ~/bin
$ rsync -avP bin/ $HOME/bin/
$ rsync -avP local/share/ $HOME/.local/share/
$ update-desktop-database -v ~/.local/share/applications/
```

or just do:  

```sh
$ cd pulsesecure
$ bash build-and-install.sh
```

## Run

Just launch:  
```sh
$ run-psecure.sh
```
or the __application desktop launcher__ that should be installed in $HOME after either manual or scripted install.
