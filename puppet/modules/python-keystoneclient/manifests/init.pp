
class python-keystoneclient {

	include python
	package { 'python-keystoneclient':
		ensure => present,
		provider => pip,
		require => File['/usr/bin/pip'],
	}

}
