#!/bin/bash
#################################################
#            Script To Install LEMP server      #
#################################################

ROOT_UID=0
MYSQL_USER=root
MYSQL_PASSWORD=root
LOGFILE=script.log
ERRORFILE=script.err

export DEBIAN_FRONTEND="noninteractive"	

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
install_package() {
	echo "Installing $1 ......"
	apt-get install $1 -y >>$LOGFILE 2>>$ERRORFILE
	echo -e "$1 installed"
}
####  Install Mysql  #######

install_mysql() {
	debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
	debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"

	sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5
   if [[ -f /etc/apt/sources.list.d/mysql.list ]]; then
	echo "mysql repo already exist"
	echo "Removing old repo and creating new"
	rm -f /etc/apt/sources.list.d/mysql.list
    else

       cat <<- EOF > /etc/apt/sources.list.d/mysql.list
       deb http://repo.mysql.com/apt/ubuntu/ xenial mysql-apt-config
       deb http://repo.mysql.com/apt/ubuntu/ xenial mysql-8.0
       deb http://repo.mysql.com/apt/ubuntu/ xenial mysql-tools
       deb-src http://repo.mysql.com/apt/ubuntu/ xenial mysql-8.0
       EOF

  fi
    apt-get update >>$LOGFILE 2>>$ERRORFILE
    apt-get install mysql-server-8.0 -y >>$LOGFILE 2>>$ERRORFILE
    echo -e "[${Gre}NOTICE${RCol}]  mysql-community-server installed"
	apt-get update
}

#############  Main script  ##########################



clear
apt-get update >>$LOGFILE 2>>$ERRORFILE
	if check_package_installed apache2; then 
	echo "Already installed"
	else 
	Install_package apache2;
	fi
	

