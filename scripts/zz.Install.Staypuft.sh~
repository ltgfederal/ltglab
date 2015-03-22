
==Install==
yum install -y http://yum.theforeman.org/nightly/el6/x86_64/foreman-release.rpm
yum -y localinstall http://mirror.pnl.gov/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install centos-release-SCL
yum -y install foreman-plugin-staypuft
yum -y install foreman-installer-staypuft
# yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
# echo /usr/share/foreman-installer/modules/foreman/manifests/remote_file.pp:6
mkdir -p /var/lib/tftpboot/boot
#yum -y install ruby193-rubygem-deface
yum -y update
# echo modify iptables
cat /proc/sys/net/ipv4/ip_forward
# change net.ipv4.ip_forward from 0 to 1
vi /etc/sysctl.conf
sysctl -e -p /etc/sysctl.conf

#Error on staypuft:
update the staypuft.gemspec located at /opt/rh/ruby193/root/usr/share/gems/specifications/staypuft-0.3.0.gemspec and modify the 1.3.0 to 1.4.0

vi /etc/hosts
192.168.2.151	foreman.hq.ltg	foreman
[SNAPSHOT DRIVE]
staypuft-installer --foreman-configure-epel-repo=true --foreman-plugin-discovery-install-images=true --foreman-admin-password="changeme"

iptables -A FORWARD -i eth0 -j ACCEPT
iptables -A FORWARD -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
service iptables save
vi /etc/sysconfig/iptables
service iptables restart

Update Centos7 mirror to 
http://mirror.centos.org/centos/7/os/$arch

Modify /etc/sysconfig/named and add OPTION statement to force IPV4 instead of IPV6 of Centos7
OPTION="-4"

===
Openstack Default

 #Dynamic
cat <<EOF > /tmp/diskpart.cfg
zerombr
clearpart --all --initlabel
part /boot --fstype ext3 --size=500 --ondisk=sda
part swap --size=1024 --ondisk=sda
part pv.01 --size=1024 --grow --ondisk=sda
volgroup vg_root pv.01
logvol  /  --vgname=vg_root  --size=1 --grow --name=lv_root
EOF

#Kickstart default: Post Installation setup
# yum -y localinstall http://mirror.pnl.gov/epel/7/x86_64/e/epel-release-7-1.noarch.rpm
yum -y localinstall http://mirror.centos.org/centos/7/extras/x86_64/Packages/epel-release-7-2.noarch.rpm
# yum -y localinstall http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y install update
yum -y install puppet

repo --name=extras

=========
eth0 => ens192, eth1 => ens224
=========

Description
The modules are installed from  foreman-installer-staypuft / hooks / lib / install_modules.sh by using the following commands in an empty directory:

mkdir modules
echo "Cloning repositories"
git clone https://github.com/redhat-openstack/astapor
git clone --recursive https://github.com/redhat-openstack/openstack-puppet-modules
# Used to define a version
#ASTAPOR_VERSION="origin/1_0_stable"
#OPENSTACK_MODULES_VERSION="origin/havana"
#pushd astapor
#git reset --hard $ASTAPOR_VERSION
#popd
#pushd openstack-puppet-modules
#git reset --hard $OPENSTACK_MODULES_VERSION
#popd
mv astapor/puppet/modules/* modules
mv openstack-puppet-modules/* modules
rm -rf astapor openstack-puppet-modules
mv modules/* /etc/puppet/environments/production/modules


