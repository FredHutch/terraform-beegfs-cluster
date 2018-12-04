#! /bin/bash

if [[ -z $1 ]]; then
  echo "please pass management server name as command line arg"
  exit
fi

apt-get install -y beegfs-client beegfs-helperd beegfs-utils

/etc/init.d/beegfs-client rebuild

if ! [[ -f /etc/beegfs/beegfs-client.conf.org ]]; then 
  cp /etc/beegfs/beegfs-client.conf /etc/beegfs/beegfs-client.conf.org
fi

/opt/beegfs/sbin/beegfs-setup-client -m $1

systemctl start beegfs-helperd
systemctl start beegfs-client
systemctl status beegfs-helperd
systemctl status beegfs-client


