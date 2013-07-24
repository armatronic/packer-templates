date > /etc/vagrant_box_build_time

yum -y install gcc bzip2 make kernel-devel-`uname -r`
yum -y update

rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
rpm -ivh http://linux.dell.com/dkms/permalink/dkms-2.2.0.3-1.noarch.rpm

yum -y update
yum -y upgrade

yum -y install gcc-c++ zlib-devel openssl-devel readline-devel sqlite-devel
yum -y install puppet facter ruby-devel rubygems
yum -y erase  gtk2 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all

# Installing chef
#gem install --no-ri --no-rdoc chef

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
if [ -f /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso ];
then
  vboxiso="/home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso"
else
  wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
  vboxiso="/tmp/VBoxGuestAdditions_$VBOX_VERSION.iso"
fi
mount -o loop $vboxiso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -f $vboxiso;

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Remove traces of mac address from network configuration
sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
rm /etc/udev/rules.d/70-persistent-net.rules

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

exit
