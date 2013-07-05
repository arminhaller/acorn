
class xvfb {

	package { [ 'xorg-x11-server-Xvfb', ]:
		ensure => present,
		alias => xvfb,
	}

	file { [ '/etc/xvfb-auth.conf', ]:
	       	ensure => present,
		content => "localhost\n",
	}

	file { [ '/etc/rc.d/init.d/xvfb', ]:
	       	ensure => present,
		source => 'puppet:///modules/xvfb/init.d/xvfb',
		mode => 0755,
	}

	file { [ '/etc/sysconfig/xvfb', ]:
	      	ensure => present,
		source => 'puppet:///modules/xvfb/sysconfig/xvfb',
	}

	service { [ 'xvfb', ]:
		ensure => running,
		require => [ Package['xorg-x11-server-Xvfb'], File['/etc/xvfb-auth.conf'], File['/etc/rc.d/init.d/xvfb'], File['/etc/sysconfig/xvfb'], ],
		
	}
}
