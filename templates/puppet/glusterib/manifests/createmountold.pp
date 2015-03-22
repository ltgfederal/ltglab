# == Class: glusterib::createmount
#
# 1. Install Gluster + XFS packages
# 2. Create mount point
# 3. Create 100G volume (gv0)
# 4. Formats volume
# 5. Mounts XFS Volume
#
#
class glusterib::createmount (
  $server1    = '',
  $server2    = '',
) {
  # Validate our data
  # Validate our regular expressions

#  include 'glusterib'
# Add Gluster Packages
#  package { 'glusterfs':
#    ensure  => 'absent',
#  }
#  package { 'glusterfs-fuse':
#    ensure  => 'absent',
#  }
  file {['/export','/export/gv0']:
     seltype => 'usr_t',
     ensure  => directory,
  }
#  exec {'lvcreate /dev/vg_labsrv/gv0':
#    command => '/sbin/lvcreate -L 100G -n gv0 vg_labsrv',
#    creates => '/dev/vg_labsrv/gv0',
#    notify  => Exec['mkfs /dev/vg_labsrv/gv0'],
#  }
#  exec {'mkfs /dev/vg_labsrv/gv0':
#    command     => '/sbin/mkfs.xfs -i size=512 /dev/vg_labsrv/gv0',
#    require     => [Exec['mkfs /dev/vg_labsrv/gv0'], Package['xfsprogs']],
#    refreshonly => true,
#  }
#  mount { '/export/gv0':
#    device  => '/dev/vg_labsrv/gv0',
#    fstype  => 'xfs',
#    options => 'defaults',
#    ensure  => mounted,
#    require => [ Exec['mkfs /dev/vg_labsrv/gv0'], File['/export/gv0'] ],
#  }


} # class global

#
# Copyright (C) 2011 Mike Arnold, unless otherwise noted.
#
class glusterib::glusrepo (
  $set_motd    = "#####",
) {
  # Validate our data
  # Validate our regular expressions
  package {'xfsprogs':
    ensure => 'installed',
  }


# Install Service
#  glusterib::server
} # class global


