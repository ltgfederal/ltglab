# Class: ltg_compute
#
# This module installs an Openstack NOVA node
#
# Parameters:
#
# Actions:
#
# Requires:
#
#
# [Remember: No empty lines between comments and class definition]
class ltg::ltg_compute (
  $template = 'ltg/motd.erb'
  ) {
    package { 'yum-plugin-priorities':
      ensure => true,
    }

    # Install Openstack packages
    package { 'openstack-nova-compute':
      ensure => true,
    }

    service { 'libvirtd':
      ensure => running,
      enable => true,
    }
}

