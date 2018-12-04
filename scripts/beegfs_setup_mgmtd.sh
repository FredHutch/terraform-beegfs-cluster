#! /bin/bash

apt-get install -y beegfs-mgmtd beegfs-utils

if ! [[ -f /etc/beegfs/beegfs-mgmtd.conf.org ]]; then 
  cp /etc/beegfs/beegfs-mgmtd.conf /etc/beegfs/beegfs-mgmtd.conf.org
fi

/opt/beegfs/sbin/beegfs-setup-mgmtd -p /loc/beegfs_mgmtd

systemctl start beegfs-mgmtd
systemctl status beegfs-mgmtd

