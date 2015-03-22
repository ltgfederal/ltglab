#!/bin/bash

# Configure Katello / Foreman
# Add LTG Username


echo "$(date) Start Software Configuration" >> /root/Sat.install.log
# Add Organization & Location
hammer -u admin -p changeme organization create --name Test_Cloud7 --description "Cloud Servers in VM internal network"
hammer -u admin -p changeme location create --name "McLean"

# Add Environments
# Library -> Test -> Prod
hammer -u admin -p changeme lifecycle-environment create --description Testing --name Test --organization Test_Cloud7 --prior Library
hammer -u admin -p changeme lifecycle-environment create --description Production --name Prod --organization Test_Cloud7 --prior Test
# Check Install
hammer -u admin -p changeme organization info --name Test_Cloud7
hammer -u admin -p changeme lifecycle-environment list --organization Test_Cloud7

#---|---------|--------
#ID | NAME    | PRIOR  
#---|---------|--------
#1  | Library |        
#2  | Test    | Library
#3  | Prod    | Test   
#---|---------|--------

# Add Products
# Puppet
hammer -u admin -p changeme product create --description "Puppet RPMS Repos" --name Puppet --organization Test_Cloud7
# CentOS
hammer -u admin -p changeme product create --description "CentOS Repos" --name CentOS --organization Test_Cloud7
# Foreman
hammer -u admin -p changeme product create --description "Foreman Repos" --name Foreman --organization Test_Cloud7
# Create New Product: Subscription
hammer -u admin -p changeme product create --description "Subscription Repos" --name Subscription --organization Test_Cloud7
# Create New Product: EPEL
hammer -u admin -p changeme product create --description "EPEL Repos" --name Epel --organization Test_Cloud7

# Check Install
#hammer -u admin -p changeme product list --organization Test_Cloud7

#---|--------------|--------------------|--------------|--------------|-----------
#ID | NAME         | DESCRIPTION        | ORGANIZATION | REPOSITORIES | SYNC STATE
#---|--------------|--------------------|--------------|--------------|-----------
#1  | Puppet       | Puppet RPMS Repos  | Test_Cloud7  | 0            | not_synced
#2  | CentOS       | CentOS Repos       | Test_Cloud7  | 0            | not_synced
#3  | Foreman      | Foreman Repos      | Test_Cloud7  | 0            | not_synced
#4  | Subscription | Subscription Repos | Test_Cloud7  | 0            | not_synced
#5  | Epel         | EPEL Repos         | Test_Cloud7  | 0            | not_synced
#---|--------------|--------------------|--------------|--------------|-----------

# Create Sync Plan
hammer -u admin -p changeme sync-plan create --description "Daily Sync 03:00 AM" --interval daily --name "Daily 3A" --sync-date "2014-05-01 03:00:00" --organization Test_Cloud7

# Add Repos to Products
echo "$(date) Start Defining Repos" >> /root/Sat.install.log
# Puppet
echo "$(date)   Puppet" >> /root/Sat.install.log
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Puppet el 6.5 x86_64"  --product Puppet --publish-via-http true --url "http://yum.puppetlabs.com/el/6.5/products/x86_64" 
# Syncrhonize the repositories
echo "$(date)     Synch Start" >> /root/Sat.install.log
echo Sync Puppet
hammer -u admin -p changeme repository synchronize --id 1
echo "$(date)     Synch Finish" >> /root/Sat.install.log

# CentOS 6 x86_64
echo "$(date)   CentOS 6 x86_64" >> /root/Sat.install.log
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Centos 6 x86_64"  --product CentOS --publish-via-http true --url "http://mirror.centos.org/centos/6/os/x86_64" 
# Syncrhonize the repositories
echo "$(date)     Synch Start" >> /root/Sat.install.log
echo Sync CentOS x86_64
hammer -u admin -p changeme repository synchronize --id 2
echo "$(date)     Sync Finish" >> /root/Sat.install.log

# CentOS 7 x86_64
echo "$(date)   CentOS 7 x86_64" >> /root/Sat.install.log
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Centos 7 x86_64"  --product CentOS --publish-via-http true --url "http://mirror.centos.org/centos/7/os/x86_64"
# Syncrhonize the repositories
echo "$(date)     Synch Start" >> /root/Sat.install.log
echo Sync CentOS 7 x86_64
hammer -u admin -p changeme repository synchronize --id 3
echo "$(date)     Sync Finish" >> /root/Sat.install.log

# Foreman
echo "$(date)   Foreman" >> /root/Sat.install.log
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Foreman Nightly"  --product Foreman --publish-via-http true --url "http://yum.theforeman.org/nightly/el6/x86_64/"
# Syncrhonize the repositories
echo "$(date)     Synch Start" >> /root/Sat.install.log
echo Sync Foreman
hammer -u admin -p changeme repository synchronize --id 4
echo "$(date)     Sync Finish" >> /root/Sat.install.log

# Subscription
echo "$(date)   Subscription" >> /root/Sat.install.log
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Subs x86_64"  --product Subscription --publish-via-http true --url "http://repos.fedorapeople.org/repos/candlepin/subscription-manager/epel-6/x86_64" 
# Syncrhonize the repositories
echo "$(date)     Synch Start" >> /root/Sat.install.log
echo Sync Subscription
hammer -u admin -p changeme repository synchronize --id 5
echo "$(date)     Sync Finish" >> /root/Sat.install.log

# EPEL
echo "$(date)   EPEL" >> /root/Sat.install.log
hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "EPEL x86_64"  --product Epel --publish-via-http true --url "http://dl.fedoraproject.org/pub/epel/6/x86_64" 
# Syncrhonize the repositories
echo "$(date)     Synch Start" >> /root/Sat.install.log
echo Sync Epel
hammer -u admin -p changeme repository synchronize --id 6
echo "$(date)     Sync Finish" >> /root/Sat.install.log


# Assign Sync Plan to Products
hammer -u admin -p changeme product set-sync-plan --name Puppet --organization Test_Cloud7 --sync-plan-id 1
hammer -u admin -p changeme product set-sync-plan --name CentOS --organization Test_Cloud7 --sync-plan-id 1
hammer -u admin -p changeme product set-sync-plan --name Foreman --organization Test_Cloud7 --sync-plan-id 1
hammer -u admin -p changeme product set-sync-plan --name Subscription --organization Test_Cloud7 --sync-plan-id 1
hammer -u admin -p changeme product set-sync-plan --name Epel --organization Test_Cloud7 --sync-plan-id 1

#hammer -u admin -p changeme repository list --organization Test_Cloud7

#---|----------------------|--------------|--------------|---------------------------------------------------------------------------------
#ID | NAME                 | PRODUCT      | CONTENT TYPE | URL                                                                             
#---|----------------------|--------------|--------------|---------------------------------------------------------------------------------
#1  | Puppet el 6.5 x86_64 | Puppet       | yum          | http://yum.puppetlabs.com/el/6.5/products/x86_64                                
#2  | Centos 6 x86_64      | CentOS       | yum          | http://mirror.centos.org/centos/6/os/x86_64                                     
#3  | Centos 7 x86_64      | CentOS       | yum          | http://mirror.centos.org/centos/7/os/x86_64                                       
#4  | Foreman Nightly      | Foreman      | yum          | http://yum.theforeman.org/nightly/el6/x86_64/                                   
#5  | Subs x86_64          | Subscription | yum          | http://repos.fedorapeople.org/repos/candlepin/subscription-manager/epel-6/x86_64
#6  | EPEL x86_64          | Epel         | yum          | http://dl.fedoraproject.org/pub/epel/6/x86_64                                   
#---|----------------------|--------------|--------------|---------------------------------------------------------------------------------


# Add Content Views
echo "$(date) Start View Creation" >> /root/Sat.install.log
echo Puppet Content View
hammer -u admin -p changeme content-view create --description "Puppet View" --name "Puppet" --organization Test_Cloud7 --repository-ids 1
hammer -u admin -p changeme content-view add-repository --id 3 --organization Test_Cloud7 --repository-id 1
echo CentOS Content View
hammer -u admin -p changeme content-view create --description "CentOS 6 x64 View" --name "CentOS_6_x64" --organization Test_Cloud7 --repository-ids 2
hammer -u admin -p changeme content-view add-repository --id 4 --organization Test_Cloud7 --repository-id 2
hammer -u admin -p changeme content-view create --description "CentOS 7 x64 View" --name "CentOS_7_x64" --organization Test_Cloud7 --repository-ids 3
hammer -u admin -p changeme content-view add-repository --id 5 --organization Test_Cloud7 --repository-id 3
echo Foreman Content view
hammer -u admin -p changeme content-view create --description "Foreman View" --name "Foreman" --organization Test_Cloud7 --repository-ids 4
hammer -u admin -p changeme content-view add-repository --id 6 --organization Test_Cloud7 --repository-id 4
echo Subscription Management Content view
hammer -u admin -p changeme content-view create --description "Sub Mgmt View" --name "Subscription" --organization Test_Cloud7 --repository-ids 5
hammer -u admin -p changeme content-view add-repository --id 7 --organization Test_Cloud7 --repository-id 5
echo Epel Content view
hammer -u admin -p changeme content-view create --description "Epel View" --name "Epel" --organization Test_Cloud7 --repository-ids 6
hammer -u admin -p changeme content-view add-repository --id 8 --organization Test_Cloud7 --repository-id 6

# Create a Version the Views
#
# hammer -u admin -p changeme content-view list --organization Test_Cloud7
#----------------|---------------------------|--------------------------------------|-----------|---------------
#CONTENT VIEW ID | NAME                      | LABEL                                | COMPOSITE | REPOSITORY IDS
#----------------|---------------------------|--------------------------------------|-----------|---------------
#2               | Default Organization View | c27f0122-359b-4576-a271-5627b013d2aa |           |               
#3               | Puppet                    | Puppet                               |           | 1             
#4               | CentOS_6_x64              | CentOS 6 x64                         |           | 2             
#5               | CentOS_7_x64              | CentOS 7 x64                         |           | 3             
#6               | Foreman                   | Foreman                              |           | 4             
#7               | Subscription              | Subscription                         |           | 5             
#8               | Epel                      | Epel                                 |           | 6             
#----------------|---------------------------|--------------------------------------|-----------|---------------


echo "$(date) Start Publish Views" >> /root/Sat.install.log
echo Puppet Content View Publish version 1
hammer -u admin -p changeme content-view publish --id 3
echo CentOS Content View Publish version 1
hammer -u admin -p changeme content-view publish --id 4
hammer -u admin -p changeme content-view publish --id 5
echo Foreman Content view Publish version 1
hammer -u admin -p changeme content-view publish --id 6
echo Subscription Mgmt Content view Publish version 1
hammer -u admin -p changeme content-view publish --id 7
echo Epel Content view Publish version 1
hammer -u admin -p changeme content-view publish --id 8


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
echo CentOS 6 x64 View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 4
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 4
echo CentOS 7 x64 View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 5
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 5
echo Foreman View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 6
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 6
echo SubsMgmg View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 7
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 7
echo Epel View -> Test -> Prod
hammer -u admin -p changeme content-view version promote --environment-id 3 --id 8
hammer -u admin -p changeme content-view version promote --environment-id 4 --id 8

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


# /bin/bash /root/Satellite-install/scripts/foreman.sh


