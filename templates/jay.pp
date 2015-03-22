# Class: motd
#
# This module manages the /etc/motd file using a template
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# include motd
#
# [Remember: No empty lines between comments and class definition]
class ltg::jay (
	$template = 'ltg/motd.erb'
	) {

	exec { 'yum Group Install Virtualization':
	  unless  => '/usr/bin/yum grouplist "Virtualization" | /bin/grep "^Installed Groups"',
	  command => '/usr/bin/yum -y groupinstall "Virtualization"',
	}
        exec { 'yum Group Install Virtualization Client':
          unless  => '/usr/bin/yum grouplist "Virtualization Client" | /bin/grep "^Installed Groups"',
          command => '/usr/bin/yum -y groupinstall "Virtualization Client"',
        }
        exec { 'yum Group Install Virtualization Platform':
          unless  => '/usr/bin/yum grouplist "Virtualization Platform" | /bin/grep "^Installed Groups"',
          command => '/usr/bin/yum -y groupinstall "Virtualization Platform"',
        }
        exec { 'yum Group Install Virtualization Tools':
          unless  => '/usr/bin/yum grouplist "Virtualization Tools" | /bin/grep "^Installed Groups"',
          command => '/usr/bin/yum -y groupinstall "Virtualization Tools"',
        }


	package { 'yum-plugin-priorities':
		ensure => true,
		}
        service { 'libvirtd':
                ensure => running,
		enable => true,
                }

	}

