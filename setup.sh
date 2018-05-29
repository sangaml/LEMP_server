#!/bin/bash
ROOT_UID=0
if [[ $EUID -ne $ROOT_UID ]]; then
    echo -e "\e[31mTo run script,  login as root\e[0m"
     exit 1
fi
