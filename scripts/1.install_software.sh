#!/bin/bash

# Estimated times
#-------------
#Thu Jun  5 21:00:46 EDT 2014 Start Install git
#Thu Jun  5 21:01:42 EDT 2014 Start Install foreman-selinux	5
#Thu Jun  5 21:06:12 EDT 2014 Start Katello Package Download	11
#Thu Jun  5 21:17:47 EDT 2014 Start Katello Installer		18
#Thu Jun  5 21:35:45 EDT 2014 Finish Software Install		0
#Thu Jun  5 21:35:45 EDT 2014 Start Software Configuration	
#Thu Jun  5 21:36:30 EDT 2014 Start Defining Repos
#Thu Jun  5 21:37:11 EDT 2014 Start Repo Synch
#Thu Jun  5 21:37:11 EDT 2014   Sync Puppet			3 hrs
#Fri Jun  6 00:26:03 EDT 2014   Sync CentOS i386		46
#Fri Jun  6 01:12:28 EDT 2014   Sync CentOS x86			20
#Fri Jun  6 01:32:57 EDT 2014   Sync Foreman			1
#Fri Jun  6 01:33:38 EDT 2014 Start View Creation
#Fri Jun  6 01:33:59 EDT 2014 Start Publish Views		16
#Fri Jun  6 01:49:45 EDT 2014 Start Promote Views		24
#Fri Jun  6 02:13:36 EDT 2014 Start Configure Networks
#Fri Jun  6 02:13:42 EDT 2014 Start PXE Linux Download		3
#Fri Jun  6 02:16:09 EDT 2014 Finish Configuration

# Start with a fresh install of CentOS
echo "-------------" >> /root/Sat.install.log
echo "$(date) Update CentOS" >> /root/Sat.install.log

yum -y update

echo "$(date) Start Install git" >> /root/Sat.install.log

yum install -y git ruby rubygems 

git clone https://github.com/Katello/katello-deploy.git
cd katello-deploy

echo "$(date) Start Install foreman-selinux" >> /root/Sat.install.log

# workaround bug 5961
#yum -y localinstall http://repos.fedorapeople.org/repos/mcpierce/qpid-cpp/epel-6/noarch/qpid-cpp-release-6-1.el6.noarch.rpm
#cp scl.repo /etc/yum.repos.d/scl.repo
#yum -y localinstall http://yum.theforeman.org/nightly/el6/x86_64/foreman-release.rpm
#yum -y install foreman-selinux


echo "$(date) Start Katello Package Download" >> /root/Sat.install.log
./setup.rb centos6 --skip-installer
echo If you get errors with missing qpid, try the katello-pulp repo
echo at http://fedorapeople.org/groups/katello/releases/yum/katello-pulp/RHEL/6Server/x86_64/
 

echo "$(date) Start Katello Installer" >> /root/Sat.install.log

service iptables stop



katello-installer --foreman-admin-password="changeme" --foreman-authentication=true --capsule-tftp=true --capsule-tftp-servername="10.10.10.10" --capsule-dhcp=true --capsule-dhcp-gateway="10.10.10.10" --capsule-dhcp-interface="eth1" --capsule-dhcp-range="10.10.10.20 10.10.10.200" --capsule-dns=true --capsule-dns-forwarders "10.10.10.10" --capsule-dns-interface="eth1" --capsule-dns-reverse="10.10.10.in-addr.arpa" --capsule-dns-zone "hq.ltg" 
 
# yum -y downgrade puppet-3.5.1 puppet-server-3.5.1
# /etc/init.d/foreman-proxy restart

echo "$(date) Finish Software Install" >> /root/Sat.install.log

## Pending items
echo Change SELINUX=permissive with 'vim /etc/selinux/config'
cat << EOF > /etc/sysconfig/selinux
SELINUX=permissive
EOF
echo vim /etc/hosts and add FQDN to list


# /bin/bash /root/Satellite-install/scripts/2.environment_config.sh

