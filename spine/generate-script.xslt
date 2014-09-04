<?xml version='1.0' ?>
<!-- $Id: generate-script.xslt 20324 2007-10-26 23:20:13Z jdutton $ -->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:fn='http://www.w3.org/2005/02/xpath-functions'
                xmlns:xsd='http://www.w3.org/2001/XSL/XMLSchema'
                xmlns:xsi='http://www.w3.org/2001/XSL/XMLSchema-instance'
                version='1.0'>

  <xsl:template match='/'>

    <xsl:variable name='name' select='template/name' />
    <xsl:variable name='repo' select='template/repository/@ref' />
    <xsl:variable name='template_id' select='template/@id' />

    <xsl:document encoding="UTF-8" method="text" href="templates/{$template_id}">#!/bin/bash
# This is a template installation script.  It wraps a yum groupinstall command with additional
# support code for an Avance guest OS install.

exec &lt; /dev/null
# Do not exit upon bad command, only when we say to exit
set +e
renice +0 $$

DEVICE=$1
UUID=$2
ROOT=$3

die() {
    msg=$1
    echo $msg
    exit 1
}

cleanup() {
    while fuser -v -k -m $ROOT
    do
        echo "Killed some processes, wait and try again"
	sleep 2
    done
    umount -l $ROOT/proc
    umount -l $ROOT
}

echo "$0 $DEVICE $UUID $ROOT"

UDEV_TIMEOUT=10
while [ ! -b $DEVICE ]; do
    sleep 1
    if [ $UDEV_TIMEOUT -le 0 ]; then
        die "The device $DEVICE does not exist!"
    fi
    UDEV_TIMEOUT=$(($UDEV_TIMEOUT - 1))
done

mkfs -t ext3 $DEVICE || die "cannot create the filesytem"
tune2fs -U $UUID $DEVICE || die "failed to set the UUID for the filesystem"

mkdir -p $ROOT
mount $DEVICE $ROOT || die "failed to mount filesystem"

# RHEL 4.2
mkdir -p $ROOT/var/rpm/lock

# CentOS 4.4
mkdir -p $ROOT/var/lock/rpm

yum -y -d 0 -e 0 --enablerepo=<xsl:value-of select='$repo'/> --installroot=$ROOT groupinstall <xsl:value-of select='$name' /> || {
    cleanup
    die "yum install failed"
}

devices="console null random zero"
for device in $devices; do
    /sbin/MAKEDEV -d $ROOT/dev -x $device
done

cat &gt; $ROOT/etc/fstab &lt;&lt; EOT
/dev/xvda  /        ext3    defaults        1 1
none      /dev/pts devpts  gid=5,mode=620  0 0
none      /dev/shm tmpfs   defaults        0 0
none      /proc    proc    defaults        0 0
none      /sys     sysfs   defaults        0 0
EOT

cat &gt; $ROOT/etc/sysconfig/network &lt;&lt; EOT
NETWORKING=yes
EOT

cat &gt; $ROOT/etc/sysconfig/network-scripts/ifcfg-eth0 &lt;&lt; EOT
ONBOOT=yes
BOOTPROTO=dhcp
EOT

cp -a /root/bang $ROOT/root

cp -a /lib/modules/$(uname -r) $ROOT/lib/modules
cleanup

</xsl:document> <!-- CMB: do not move this element -->
  </xsl:template>
</xsl:stylesheet>
