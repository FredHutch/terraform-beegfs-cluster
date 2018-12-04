#!/bin/bash
# 2015-11-03 Version 1
# 2015-11-04 Version 2 Packages are in our local "fhcrc" repo on octopus.
#

# Setup script for ZFS on spinning disks.
echo; echo "Setup script for ZFS is starting..."

# This script can only run on certain systems.
case `hostname` in
      bee*)
   ;;  
   *) echo "You can not run this script on this system -- exiting."
      exit 0
   ;;
esac

# This script absolutely must be run as root.
if [ $USER != "root" ]
then
   echo "You must be root to run this script -- exiting."
   exit 0
fi

# Version 1: Can't do apt-add-repository without this first.
# echo; echo "Install apt-add-repository command..."
# /usr/bin/apt-get -y install software-properties-common

# Version 1: Install the ZFS on Ubuntu software. Add a test to see if this was previously done.
# echo; echo "Adding ppa:zfs-native/stable repo..."
# /usr/bin/add-apt-repository -y ppa:zfs-native/stable

echo ""
read -p "Warning: This may destroy a local ZPOOL! Continue? y/n " REPLY 
if [[ "$REPLY" != "y" ]]; then
  exit
fi

# Import and destroy any existing zpools so they don't conflict.
echo; echo "Checking for existing zpool..."
importid=$(/sbin/zpool import 2> /dev/null | /usr/bin/awk '/id:/ {print $2}')
importpool=$(/sbin/zpool import 2> /dev/null | /usr/bin/awk '/pool:/ {print $2}')
if [ -n "$importid" ]
then
  echo; echo "zpool found, importing $importid..."
  /sbin/zpool import -f $importid
  /bin/sleep 5
  echo; echo "Destroying $importpool..."
  /sbin/zpool destroy $importpool
  /bin/sleep 5
fi

# Create /etc/zfs/vdev_id.conf containing aliases for ZFS data disks.
echo; echo "Building /etc/zfs/vdev_id.conf alias table..."
cd /dev/disk/by-path
idisk=1
for disk in vda vdb vdc; do
   disk_data[$idisk]=`/bin/ls -l virtio* | /bin/grep "$disk\$" | /usr/bin/awk '{print $9}'`
   (( idisk=idisk+1 ))
done

cd /etc/zfs
echo "run 'udevadm trigger' after updating this file" >vdev_id.conf
idisk=1
for diskalias in d1 d2 d3; do
   echo "alias $diskalias        ${disk_data[$idisk]}" >>vdev_id.conf
   (( idisk=idisk+1 ))
done

/bin/cat vdev_id.conf

echo; echo "Doing udevadm trigger, then waiting..."
/sbin/udevadm trigger
/sbin/udevadm settle
/bin/sleep 1

# Create /etc/modprobe.d/zfs.conf containing:
echo; echo "Creating /etc/modprobe.d/zfs.conf..."
cd /etc/modprobe.d
#/bin/cat - <<TheEnd >zfs.conf
#options zfs zfs_arc_min=4294967296
#options zfs zfs_arc_max=34359738368
#TheEnd

# Create the zpool.
echo; echo "Creating a zpool named loc on spinning disks..."
#/sbin/zpool create -f loc mirror a0 b0 mirror a1 b1 mirror a2 b2
/sbin/zpool create -f loc raidz d1 d2 d3

#echo; echo "Creating the zpool cache on NVMe SSD..."
#/sbin/zpool add -f loc cache rssda3

#echo; echo "Creating the zpool log on NVMe SSD..."
#/sbin/zpool add -f loc log mirror rssda1 rssda2

echo; echo "Setting compression mode to lz4..."
/sbin/zfs set compression=lz4 loc

echo; echo "Showing off new zpool..."
/sbin/zpool status loc

echo; echo "Finished."
exit 0
