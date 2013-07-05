
class pyro3 {
	include python

	package { 'pyro':
		ensure => installed,
		provider => pip,
		alias => pyro3,
		require => File['/usr/bin/pip'],
	}

}

