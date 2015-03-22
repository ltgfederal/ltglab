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
class ltg::varmotd (
	$template = 'ltg/varmotd.erb'
	) {
	if $::kernel == 'Linux' {
		file { '/etc/motd':
			ensure => file,
			backup => false,
			content => template($template),
		}
	}
}

