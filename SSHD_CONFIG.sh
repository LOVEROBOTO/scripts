#!/bin/bash
#
# Description:
# This script sets certain parameters in /etc/ssh/sshd_config.

# * Check whether a /etc/ssh/sshd_config file exists
# * Creates a backup of the file
# * Edit the file to set certain parameters
# * Reload the sshd configuration
# To enable debugging mode remove '#' from the following line
#set -x
# Variables

file="$1"
PermitRootLogin yes
PasswordAuthentication yes

# Functions
usage(){
  cat << EOF
    usage: $0 ARG1
    ARG1 Name of the sshd_config file to edit.
    In case ARG1 is empty, /etc/ssh/sshd_config will be used as default.

    Description:
    This script sets certain parameters in /etc/ssh/sshd_config.
    It's not production ready and only used for training purposes.

    What should it do?
    * Check whether a /etc/ssh/sshd_config file exists
    * Create a backup of this file
    * Edit the file to set certain parameters
EOF
}

backup_sshd_config(){
  if [ -f ${file} ]
  then
    /usr/bin/cp ${file} ${file}.1
  else
    /usr/bin/echo "File ${file} not found."
    exit 1
  fi
}

edit_sshd_config(){
  for PARAM in ${param[@]}
  do
    /usr/bin/sed -i '/^'"${PARAM}"'/d' ${file}
    /usr/bin/echo "All lines beginning with '${PARAM}' were deleted from ${file}."
  done
  /usr/bin/echo "${param[1]} yes" >> ${file}
  /usr/bin/echo "'${param[1]} yes' was added to ${file}."
  /usr/bin/echo "${param[2]} yes" >> ${file}
  /usr/bin/echo "'${param[2]} yes' was added to ${file}"
}

reload_sshd(){
  /usr/bin/systemctl reload sshd.service
  /usr/bin/echo "Run '/usr/bin/systemctl reload sshd.service'...OK"
}

# main
while getopts .h. OPTION
do
  case $OPTION in
    h)
    usage
    exit;;
    ?)
    usage
    exit;;
  esac
done

if [ -z "${file}" ]
then

file="/etc/ssh/sshd_config"
fi
backup_sshd_config
edit_sshd_config
reload_sshd