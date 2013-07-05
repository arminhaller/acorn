
class ssh::x11_forwarding ($ensure = yes) {

	$xauth = $operatingsystem ? {
			centos => 'xorg-x11-xauth',
			redhat => 'xorg-x11-xauth',
			debian => 'xauth',
			ubuntu => 'xauth',
			default => undef,
		}

	package { $xauth:
		ensure => $ensure ? {
		                   yes => present,
		                   no => absent,
		                   default => present,
		          },
		alias => xauth,
	}

	file_line { "x11_forwarding_enable":
		path => "/etc/ssh/sshd_config",
		match => "^X11Forwarding ",
		line => "X11Forwarding $ensure",
		notify => Service["$ssh::ssh_service"],
	}

}
