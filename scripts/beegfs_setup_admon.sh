#! /bin/bash

apt-get install -y beegfs-admon

if ! [[ -f /etc/beegfs/beegfs-admon.conf.org ]]; then 
  mv /etc/beegfs/beegfs-admon.conf /etc/beegfs/beegfs-admon.conf.org
fi

if [[ -z $1 ]]; then
  echo "please pass management server name as command line arg"
  exit
fi


echo "sysMgmtdHost = $1" > /etc/beegfs/beegfs-admon.conf

systemctl start beegfs-admon
systemctl status beegfs-admon

