#
# Copyright (C) 2011 Mike Arnold, unless otherwise noted.
#
class glusterib::glusrepo (
  $set_motd    = "#####",
) {
  # Validate our data
  # Validate our regular expressions

file {'repo':
path 	=> '/etc/yum.repos.d/GlusterRepo.repo',
ensure 	=> present,
source  => 'puppet:///modules/glusterib/glusrepo.txt',
	}

# Install Service
#  glusterib::server
} # class global
