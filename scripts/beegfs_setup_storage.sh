#! /bin/bash

if [[ -z $1 ]]; then
  echo "please pass management server name as command line arg"
  exit
fi

apt-get install -y beegfs-storage

if ! [[ -f /etc/beegfs/beegfs-storage.conf.org ]]; then 
  cp /etc/beegfs/beegfs-storage.conf /etc/beegfs/beegfs-storage.conf.org
fi

host=$(hostname)
hostnum=${host//[!0-9]/}


/opt/beegfs/sbin/beegfs-setup-storage -p /loc/beegfs_data -s ${hostnum} -i ${hostnum}1 -m $1

systemctl start beegfs-storage
systemctl status beegfs-storage



