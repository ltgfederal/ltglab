#!/bin/bash

# Configure Katello / Foreman
# Add LTG Username


echo "$(date) Start Software Configuration" >> /root/Sat.install.log
# Add Organization
hammer -u admin -p changeme organization create --name Test_Cloud7 --description "Cloud Servers in VM internal network"

# Add Environments
# Library -> Test -> Prod
hammer -u admin -p changeme lifecycle-environment create --description Testing --name Test --organization Test_Cloud7 --prior Library
hammer -u admin -p changeme lifecycle-environment create --description Production --name Prod --organization Test_Cloud7 --prior Test
# Check Install
hammer -u admin -p changeme organization info --name Test_Cloud7
hammer -u admin -p changeme lifecycle-environment list --organization Test_Cloud7

# Add Products
# Puppet
hammer -u admin -p changeme product create --description "Puppet RPMS Repos" --name Puppet --organization Test_Cloud7
# CentOS
hammer -u admin -p changeme product create --description "CentOS Repos" --name CentOS --organization Test_Cloud7
# Foreman
hammer -u admin -p changeme product create --description "Foreman Repos" --name Foreman --organization Test_Cloud7
# Check Install
hammer -u admin -p changeme product list --organization Test_Cloud7

#---|---------|--------------|--------------|-----------
#ID | NAME    | ORGANIZATION | REPOSITORIES | SYNC STATE
#---|---------|--------------|--------------|-----------
#2  | CentOS  | Test_Cloud7  | 0            | not_synced
#3  | Foreman | Test_Cloud7  | 0            | not_synced
#1  | Puppet  | Test_Cloud7  | 0            | not_synced
#---|---------|--------------|--------------|-----------

# Add Repos to Products
echo "$(date) Start Defining Repos" >> /root/Sat.install.log
# Puppet
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Puppet el 6.5 x86_64"  --product Puppet --publish-via-http true --url "http://yum.puppetlabs.com/el/6.5/products/x86_64" 
# CentOS
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Centos 6 x86_64"  --product CentOS --publish-via-http true --url "http://mirror.centos.org/centos/6/os/x86_64" 
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Centos 6 i386"  --product CentOS --publish-via-http true --url "http://mirror.centos.org/centos/6/os/i386" 
# Foreman
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Foreman Nightly"  --product Foreman --publish-via-http true --url "http://yum.theforeman.org/nightly/el6/x86_64/"

# Create Sync Plan
hammer -u admin -p changeme sync-plan create --description "Daily Sync 03:00 AM" --interval daily --name "Daily 3A" --sync-date "2014-05-01 03:00:00" --organization Test_Cloud7

# Assign Sync Plan to Products
hammer -u admin -p changeme product set-sync-plan --name Puppet --organization Test_Cloud7 --sync-plan-id 1
hammer -u admin -p changeme product set-sync-plan --name CentOS --organization Test_Cloud7 --sync-plan-id 1
hammer -u admin -p changeme product set-sync-plan --name Foreman --organization Test_Cloud7 --sync-plan-id 1

#hammer -u admin -p changeme repository list --organization Test_Cloud7
#---|----------------------|-------------
#ID | NAME                 | CONTENT TYPE
#---|----------------------|-------------
#3  | Centos 6 i386        | yum         
#2  | Centos 6 x86_64      | yum         
#4  | Foreman Nightly      | yum         
#1  | Puppet el 6.5 x86_64 | yum         
#---|----------------------|-------------

# Syncrhonize the repositories
echo "$(date) Start Repo Synch" >> /root/Sat.install.log
echo "$(date)   Sync Puppet" >> /root/Sat.install.log
echo Sync Puppet
hammer -u admin -p changeme repository synchronize --id 1
echo "$(date)   Sync CentOS i386" >> /root/Sat.install.log
echo Sync CentOS i386
hammer -u admin -p changeme repository synchronize --id 2
echo "$(date)   Sync CentOS x86" >> /root/Sat.install.log
echo Sync CentOS x86
hammer -u admin -p changeme repository synchronize --id 3
echo "$(date)   Sync Foreman" >> /root/Sat.install.log
echo Sync Foreman
hammer -u admin -p changeme repository synchronize --id 4

# Add Content Views
echo "$(date) Start View Creation" >> /root/Sat.install.log
echo Puppet Content View
hammer -u admin -p changeme content-view create --description "Puppet View" --name "Puppet" --organization Test_Cloud7 --repository-ids 1
echo CentOS Content View
hammer -u admin -p changeme content-view create --description "CentOS Base View" --name "CentOS Base" --organization Test_Cloud7 --repository-ids 2,3
echo Foreman Content view
hammer -u admin -p changeme content-view create --description "Foreman View" --name "Foreman" --organization Test_Cloud7 --repository-ids 4

# Create a Version the Views
#
# hammer -u admin -p changeme content-view list --organization Test_Cloud7
#----------------|---------------------------|---------------------------|-----------|---------------
#CONTENT VIEW ID | NAME                      | LABEL                     | COMPOSITE | REPOSITORY IDS
#----------------|---------------------------|---------------------------|-----------|---------------
#3               | Puppet                    | Puppet                    |           | 1             
#2               | Default Organization View | Default_Organization_View |           |               
#5               | Foreman                   | Foreman                   |           | 4             
#4               | CentOS Base               | CentOS_Base               |           | 3, 2          
#----------------|---------------------------|---------------------------|-----------|---------------

echo "$(date) Start Publish Views" >> /root/Sat.install.log
echo Puppet Content View Publish version 1
hammer -u admin -p changeme content-view publish --id 3
echo CentOS Content View Publish version 1
hammer -u admin -p changeme content-view publish --id 4
echo Foreman Content view Publish version 1
hammer -u admin -p changeme content-view publish --id 5

# Promote the View
# hammer -u admin -p changeme lifecycle-environment list --organization Test_Cloud7
#---|---------|--------
#ID | NAME    | PRIOR  
#---|---------|--------
#2  | Library |        
#4  | Prod    | Test   
#3  | Test    | Library
#---|---------|--------

#hammer -u admin -p changeme content-view version list --content-view-id 3
#---|----------|---------|-----------------|-------------------|-------------------
#ID | NAME     | VERSION | CONTENT VIEW ID | CONTENT VIEW NAME | CONTENT VIEW LABEL
#---|----------|---------|-----------------|-------------------|-------------------
#3  | Puppet 1 | 1       | 3               | Puppet            | Puppet            
#---|----------|---------|-----------------|-------------------|-------------------

echo "$(date) Start Promote Views" >> /root/Sat.install.log
echo Puppet View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 3
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 3
echo CentOS View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 4
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 4
echo Foreman View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 5
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 5

echo "$(date) Start Configure Networks" >> /root/Sat.install.log
echo Create Default Networks
hammer -u admin -p changeme subnet create --name "Management Network" --network "10.10.10.0" --mask "255.255.255.0" --gateway "10.10.10.10" --dns-primary "10.10.10.10" --from "10.10.10.20" --to "10.10.10.50" --domain-ids 1 --dhcp-id 1 --dns-id 1 --tftp-id 1
hammer -u admin -p changeme subnet create --name "Internal Network" --network "10.10.6.0" --mask "255.255.255.0" --gateway "10.10.6.10" --dns-primary "10.10.6.10" --from "10.10.6.20" --to "10.10.6.50" --domain-ids 1 --dhcp-id 1 --dns-id 1 --tftp-id 1

echo "$(date) Start PXE Linux Download" >> /root/Sat.install.log
wget http://downloads.theforeman.org/discovery/releases/latest/foreman-discovery-image-latest.el6.iso-vmlinuz 
mv foreman-discovery-image-latest.el6.iso-vmlinuz /var/lib/tftpboot/boot/discovery-vmlinuz
wget http://downloads.theforeman.org/discovery/releases/latest/foreman-discovery-image-latest.el6.iso-img
mv foreman-discovery-image-latest.el6.iso-img /var/lib/tftpboot/boot/discovery-initrd.img
chown -R foreman-proxy:foreman-proxy /var/lib/tftpboot/boot/*

echo "$(date) Finish Configuration" >> /root/Sat.install.log
echo "-------------" >> /root/Sat.install.log


/bin/bash /root/Satellite-install/scripts/foreman.sh


