#!/bin/bash
#################################################
#            Script To Install LEMP server      #
#################################################

ROOT_UID=0
LOGFILE=script.log
ERRORFILE=script.err

if [[ $EUID -ne $ROOT_UID ]]; then
    echo -e "\e[31mTo run script,  login as root\e[0m"
     exit 1
fi
#Checked if package is installed or not 
check_package_installed() {
	echo -e "Check if $1 is already installed"
	INSTALLED=$(dpkg -l | grep $1)
	if [[ $INSTALLED != "" ]]; then 
	return 0	
	#Installed
	else 
	return 1
	fi
}

#Installed the package
Install_package() {
	echo "Installing $1 ......"
	apt-get install $1 -y >>$LOGFILE 2>>$ERRORFILE
	echo -e "$1 installed"
}
clear
apt-get update >>$LOGFILE 2>>$ERRORFILE
	if check_package_installed apache2; then 
	echo "Already installed"
	else 
	Install_package apache2;
	fi
	

