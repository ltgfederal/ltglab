# == Class: glusterib::createmount
#
# 1. Install Gluster + XFS packages
# 2. Create mount point
# 3. Create 100G volume (gv0)
# 4. Formats volume
# 5. Mounts XFS Volume
#
#
define line($file, $line, $ensure = 'present') {
    case $ensure {
        default : { err ( "unknown ensure value ${ensure}" ) }
        present: {
            exec { "/bin/echo '${line}' >> '${file}'":
                unless => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
        absent: {
            exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
                onlyif => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
    }
}
class glusterib::createmount (
  $set_motd    = "#####",
) {
  package {'xfsprogs':
    ensure => 'installed',
  }
  package {'glusterfs-server':
    ensure => 'installed',
    notify => Exec['lvcreate vg_labsrv'],  
  }
  service { 'glusterd':
      ensure    => running,
      enable    => true,
      require   => Package['glusterfs-server']
  }
  exec {'lvcreate vg_labsrv':
    command     => '/sbin/lvcreate -l 100%FREE -n gv0 vg_labsrv',
    notify      => Exec['mkfs disk'],
    refreshonly => true,
  }
  exec {'mkfs disk':
    command     => '/sbin/mkfs.xfs -i size=512 /dev/vg_labsrv/gv0',
    require     => [Exec['lvcreate vg_labsrv'], Package['xfsprogs']],
    refreshonly => true,
  }
  exec{'/bin/mkdir -p /export/gv0':
       unless => '/usr/bin/test -d /export/gv0',
  }
  mount { '/export/gv0':
         ensure  => 'mounted',
         device  => '/dev/mapper/vg_labsrv-gv0',
         fstype  => 'xfs',
         options => 'defaults',
         dump    =>  '1',
         pass    =>  '2',
         require  => [Exec['/bin/mkdir -p /export/gv0'], Exec['mkfs disk']],
     }
} # class global


