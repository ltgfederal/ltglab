#!/bin/bash

# Start with a fresh install of CentOS
echo "-------------" >> /root/Sat.install.log
echo "$(date) Start Install git" >> /root/Sat.install.log

yum install -y git ruby rubygems
git clone https://github.com/Katello/katello-deploy.git
cd katello-deploy

echo "$(date) Start Install foreman-selinux" >> /root/Sat.install.log

yum -y localinstall http://repos.fedorapeople.org/repos/mcpierce/qpid-cpp/epel-6/noarch/qpid-cpp-release-6-1.el6.noarch.rpm
cp scl.repo /etc/yum.repos.d/scl.repo
yum -y localinstall http://yum.theforeman.org/nightly/el6/x86_64/foreman-release.rpm
yum -y install foreman-selinux

echo "$(date) Start Katello Package Download" >> /root/Sat.install.log
./setup.rb centos6 --skip-installer

echo "$(date) Start Katello Installer" >> /root/Sat.install.log

service iptables stop

katello-installer --foreman-authentication=true --capsule-tftp=true --capsule-tftp-servername="192.168.1.80" --capsule-dhcp=true --capsule-dhcp-gateway="10.10.10.10" --capsule-dhcp-interface="eth1" --capsule-dhcp-range="10.10.10.20 10.10.10.200" --capsule-dns=true --capsule-dns-forwarders "10.10.10.10" --capsule-dns-interface="eth1" --capsule-dns-zone "miwcasa" 
 
yum -y downgrade puppet-3.5.1 puppet-server-3.5.1
/etc/init.d/foreman-proxy restart

echo "$(date) Finish Software Install" >> /root/Sat.install.log

## Pending items
echo Change SELINUX=permissive with 'vim /etc/selinux/config'
echo vim /etc/hosts and add FQDN to list
echo update /etc/foreman-proxy/settings.yml lookingfor dns_key to false
echo afterwards /etc/init.d/foreman-proxy restart
echo restart katello with katello-restart

echo /bin/bash /root/Satellite-install/scripts/environment_config.sh

