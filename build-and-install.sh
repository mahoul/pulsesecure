#!/bin/bash

die(){
	log_entry $1
	exit 2
}

get_log_date(){
	date --rfc-3339=seconds | awk '{print substr($0,1,19)}'
}

log_entry(){
	log_date=$(get_log_date)
	echo -e "$log_date $1" | tee -a $LOG_FILE
}

LOG_FILE="${0%.sh}.log"

truncate -s 0 $LOG_FILE

# Launch container build
log_entry "Launching $USER/pulsesecure image build ..."
if ! docker build -t $USER/pulsesecure .; then
	die "Failed on docker image building process" 1
fi

log_entry "Making scripts executable before copy ..."
find bin/ etc/ -iname "*.sh" -exec chmod +x {} \;

log_entry "Installing NetworkManager config files and restarting service ... "
# On successful build, copy NetworkManager conf files and restart 
# service.
if ! sudo rsync -avP etc/NetworkManager/ /etc/NetworkManager/; then
	die "Failure on installing NetworkManager config files" 2
fi

if ! sudo systemctl restart NetworkManager; then
	die "Failure on NetworkManager service restart" 3
fi

log_entry "Installing run scripts in $HOME/bin/ ..."
[ ! -d $HOME/bin ] && mkdir $HOME/bin
rsync -avP bin/ $HOME/bin/

log_entry "Installing container launch desktop file and icon in \
$HOME/.local./share ..."
# Copy application launcher and icon to $HOME/.local/share dirs
if ! rsync -avP local/share/ $HOME/.local/share/; then
	die "Failure installing $USER launcher files" 4
else
	log_entry "Updating $USER desktop applications database ..."
	update-desktop-database -v ~/.local/share/applications/
fi

