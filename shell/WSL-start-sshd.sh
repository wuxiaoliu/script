#!/bin/bash

# This simple open WSL sshd service guide (you can use xshell ssh to WSL,suitable for Win10 1803 version),follow this step:

# sudo apt-get purge openssh-server
# sudo apt-get install openssh-server
# sudo vim /etc/ssh/sshd_config $$ setting PermitRootLogin yes
# AllowUsers yourusername
# PasswordAuthentication yes
# UsePrivilegeSeparation no
sudo service ssh --full-restart
# https://superuser.com/questions/1111591/how-can-i-ssh-into-bash-on-ubuntu-on-windows-10?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
