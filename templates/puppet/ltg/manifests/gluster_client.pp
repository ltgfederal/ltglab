# Gluster Client
# 1. Verify that GlusterFS package is installed
# 2. Create mount point
# 3. Mount!
#
# Parameters:
#  $peers:
#    Array of peer IP addresses to be added. Default: empty
#
# Sample Usage :
#  class { 'glusterfs::server':
#    peers => $::hostname ? {
#      'server1' => '192.168.0.2',
#      'server2' => '192.168.0.1',
#    },
#  }
#
class ltg::gluster_client (
  $peers = ['labsrv05.hq.ltg']
) {

  # Main package and service it provides
  package { 'glusterfs':
    ensure => installed,
  }
  package { 'glusterfs-rdma':
    ensure  => 'installed',
    require => Package['glusterfs'],
  }
  package { 'glusterfs-fuse':
    ensure   => 'installed',
    require => Package['glusterfs-rdma'],
  }
  package { 'fuse':
    ensure  => 'installed',
    require => Package['glusterfs-fuse'],
  }
  package { 'fuse-libs':
    ensure  => 'installed',
    require => Package['fuse'],
    notify => [ Exec['/bin/mkdir -p /mount/gglance'],
		Exec['/bin/mkdir -p /mount/gswift'],
		Exec['/bin/mkdir -p /mount/gcinder']
		],
  }

  # Mounts
  exec{'/bin/mkdir -p /mount/gglance':
    unless => '/usr/bin/test -d /mount/gglance',
    notify => Mount['mount gglance'],
  }
  exec{'/bin/mkdir -p /mount/gswift':
    unless => '/usr/bin/test -d /mount/gswift',
    notify => Mount['mount gswift'],
  }
  exec{'/bin/mkdir -p /mount/gcinder':
    unless => '/usr/bin/test -d /mount/gcinder',
    notify => Mount['mount gcinder'],
  }
    mount{'mount gcinder':
        name => '/mount/gcinder',
        atboot => true,
        ensure => mounted,
        device => "$peers:/gcinder",
        fstype => 'glusterfs',
        options => "defaults,_netdev",
	dump    => '0',
	pass    => '0'
  }
  mount{'mount gglance':
	name => '/mount/gglance',
	atboot => true,
	ensure => mounted,
#	device => 'labsrv05:/gglance',
        device => "$peers:/gglance",
	fstype => 'glusterfs',
	options => "defaults,_netdev",
	dump	=> '0',
	pass	=> '0'
  }
  mount{'mount gswift':
        name => '/mount/gswift',
        atboot => true,
        ensure => mounted,
        device => "$peers:/gswift",
        fstype => 'glusterfs',
        options => "defaults,_netdev",
	dump	=> '0',
	pass	=> '0'
  }

}



