#! /bin/bash

if [[ -z $1 ]]; then
  echo "please pass management server name as command line arg"
  exit
fi

apt-get install -y beegfs-meta

if ! [[ -f /etc/beegfs/beegfs-meta.conf.org ]]; then 
  cp /etc/beegfs/beegfs-meta.conf /etc/beegfs/beegfs-meta.conf.org
fi

host=$(hostname)
hostnum=${host//[!0-9]/}

/opt/beegfs/sbin/beegfs-setup-meta -p /loc/beegfs_meta -s ${hostnum} -m $1

systemctl start beegfs-meta
systemctl status beegfs-meta

