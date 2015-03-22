
class ltg::fixedmotd () {
	file {'/etc/motd':
		ensure 	=> present,
		source  => 'puppet:///modules/ltg/motdfixed.txt',
	}

}
