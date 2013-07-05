
class postgresql {

	package { [ 'postgresql', ]:
		ensure => present,
	}

}
