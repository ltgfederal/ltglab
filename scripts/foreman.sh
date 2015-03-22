#!/bin/bash
# Configure Foreman Provisioning

## Manage organizations

# hammer> location list
#---|--------
#ID | NAME   
#---|--------
#2  | Default
#---|--------


#hammer -u admin -p changeme organization list
#---|------------------|------------------|-------------------------------------
#ID | NAME             | LABEL            | DESCRIPTION                         
#---|------------------|------------------|-------------------------------------
#1  | ACME_Corporation | ACME_Corporation | ACME_Corporation Organization       
#3  | Test_Cloud7      | Test_Cloud7      | Cloud Servers in VM internal network
#---|------------------|------------------|-------------------------------------

# hammer> subnet list
#---|--------------------|------------|--------------
#ID | NAME               | NETWORK    | MASK         
#---|--------------------|------------|--------------
#1  | Management Network | 10.10.10.0 | 255.255.255.0
#2  | Internal Network   | 10.10.6.0  | 255.255.255.0
#---|--------------------|------------|--------------


# Associate Organization to Locations
hammer -u admin -p changeme location add-organization --id 2 --organization Test_Cloud7

# Associate subnets to Location
hammer -u admin -p changeme location add-subnet --name Default --subnet "Management Network"
hammer -u admin -p changeme location add-subnet --name Default --subnet "Internal Network"

# Associate Domains to Location
hammer -u admin -p changeme location add-domain --domain-id 1 --name Default

# Associate templates to Location
# All
# Associate Media to Location
# All


echo Manually perform the following tasks
echo -------------
echo Infrastructure -> Subnets
echo "Then for each Subnet, Organization -> Test_Cloud7"
echo hammer -u admin -p changeme organization add-subnet --name Test_Cloud7 --subnet "Management Network"
echo hammer -u admin -p changeme organization add-subnet --name Test_Cloud7 --subnet "Internal Network"
echo -------------
echo Infrastructure -> Domains -> Organization -> Test_Cloud7
echo -------------
echo Manage Organizations -> Templates -> All templates
echo -------------
echo Administer -> Settings -> Discover
echo discovery_location => Default and discovery_organization => Test_Cloud7
echo -----------
echo Execute these commands
echo hammer -u admin -p changeme os add-ptable --id 1 --ptable-id 7
echo hammer -u admin -p changeme os add-config-template --config-template-id 1 --id 1
echo hammer -u admin -p changeme os set-default-template --config-template-id 1 --id 1
echo hammer -u admin -p changeme location add-medium --id 2 --medium-id 14



#pause

#hammer> partition-table list
#---|------------------------------|----------
#ID | NAME                         | OS FAMILY
#---|------------------------------|----------
#1  | AutoYaST entire SCSI disk    | Suse     
#2  | AutoYaST entire virtual disk | Suse     
#3  | AutoYaST LVM                 | Suse     
#4  | FreeBSD                      | Freebsd  
#5  | Jumpstart default            | Solaris  
#6  | Jumpstart mirrored           | Solaris  
#10 | Junos default fake           | Junos    
#7  | Kickstart default            | Redhat   
#9  | Preseed custom LVM           | Debian   
#8  | Preseed default              | Debian   
#---|------------------------------|----------

# Add Partition table to CentOS
##################################################################
# hammer -u admin -p changeme os add-ptable --id 1 --ptable-id 7
##################################################################
#hammer> template list
#---|-------------------------------|----------
#ID | NAME                          | TYPE     
#---|-------------------------------|----------
#4  | AutoYaST default              | provision
#6  | AutoYaST default PXELinux     | PXELinux 
#5  | AutoYaST SLES default         | provision
#40 | Boot disk iPXE - generic host | Bootdisk 
#39 | Boot disk iPXE - host         | Bootdisk 
#30 | epel                          | snippet  
#31 | fix_hosts                     | snippet  
#7  | FreeBSD (mfsBSD) finish       | finish   
#8  | FreeBSD (mfsBSD) provision    | provision
#9  | FreeBSD (mfsBSD) PXELinux     | PXELinux 
#32 | freeipa_register              | snippet  
#10 | Grubby default                | script   
#33 | http_proxy                    | snippet  
#11 | Jumpstart default             | provision
#12 | Jumpstart default finish      | finish   
#13 | Jumpstart default PXEGrub     | PXEGrub  
#29 | Junos default finish          | finish   
#27 | Junos default SLAX            | provision
#28 | Junos default ZTP config      | ZTP      
#36 | Katello Kickstart Default     | provision
#---|-------------------------------|----------
#List next page? (Y/n): y
#---|------------------------------------|----------
#ID | NAME                               | TYPE     
#---|------------------------------------|----------
#37 | Katello Kickstart Default for RHEL | provision
#14 | Kickstart default                  | provision
#16 | Kickstart default finish           | finish   
#18 | Kickstart default iPXE             | iPXE     
#17 | Kickstart default PXELinux         | PXELinux 
#19 | Kickstart default user data        | user_data
#15 | Kickstart RHEL default             | provision
#20 | Preseed default                    | provision
#21 | Preseed default finish             | finish   
#23 | Preseed default iPXE               | iPXE     
#22 | Preseed default PXELinux           | PXELinux 
#24 | Preseed default user data          | user_data
#34 | puppet.conf                        | snippet  
#3  | PXEGrub default local boot         | PXEGrub  
#2  | PXELinux default local boot        | PXELinux 
#1  | PXELinux global default            | PXELinux 
#35 | redhat_register                    | snippet  
#38 | subscription_manager_registration  | snippet  
#25 | UserData default                   | user_data
#26 | WAIK default PXELinux              | PXELinux 
#---|------------------------------------|----------

#############################################################################
# Add kickstart file to CentOS
#hammer -u admin -p changeme os add-config-template --config-template-id 1 --id 1
#hammer -u admin -p changeme os set-default-template --config-template-id 1 --id 1

# Add CenOS Production media to CentOS
#hammer -u admin -p changeme location add-medium --id 2 --medium-id 14
##############################################################################

echo Test VM: 00:50:56:83:DA:EF
echo Hosts -> Provisioning Templates -> Kickstart Default -> Association -> Select CentOS.
echo Add instalation media to Default Location
echo Hosts -> Provisioning Templates -> Kickstart default PXELInux -> Association -> Select CentOS
echo Hosts -> Operating Systems -> CentOS -> Templates -> provision -> kickstart default
echo Update the DNS configuration files.
echo Update resolv.conf (10.10.10.10)
echo Update dhcpd.conf 
echo Update zones.conf
echo Ensure that /var/named/dynamic is chown -R named:named
echo restart dhcp -> service names restart   service foreman-proxy restart
echo Add provisioning templates to Test_Cloud7 / Default and to OS!
echo Create a new Activation Key for PROD and CentOS Full environment

######################################################################
#DONE
# Create New Product: Subscription
#hammer -u admin -p changeme product create --description "Subscription Repos" --name Subscription --organization Test_Cloud7
# Create New Product: EPEL
#hammer -u admin -p changeme product create --description "EPEL Repos" --name Epel --organization Test_Cloud7

# Add Repos to Products
# Subscription
#hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "Subs x86_64"  --product Subscription --publish-via-http true --url "http://repos.fedorapeople.org/repos/candlepin/subscription-manager/epel-6/x86_64" 
# EPEL
#hammer -u admin -p changeme repository create --organization Test_Cloud7 --content-type yum --name  "EPEL x86_64"  --product Epel --publish-via-http true --url "http://dl.fedoraproject.org/pub/epel/6/x86_64" 


# After a reboot, some services from pult are not started correctly. To correct, run the following commands:
#
# service pulp_celerybeat start
# service pulp_workers start
# service pulp_resource_manager start

# Assign Sync Plan to Products
#hammer -u admin -p changeme product set-sync-plan --name Subscription  --organization Test_Cloud7 --sync-plan-id 1
#hammer -u admin -p changeme product set-sync-plan --name Epel --organization Test_Cloud7 --sync-plan-id 1

# Syncrhonize the repositories
echo "$(date) Start Repo Synch" >> /root/Sat.install.log
echo "$(date)   Sync Subscription " >> /root/Sat.install.log
echo Sync Subscription
hammer -u admin -p changeme repository synchronize --id 5
echo "$(date)   Sync Epel " >> /root/Sat.install.log
echo Sync Epel
hammer -u admin -p changeme repository synchronize --id 6

