
class python-novaclient {

	include python
	package { 'python-novaclient':
		ensure => present,
		provider => pip,
		require => File['/usr/bin/pip'],
	}

}
