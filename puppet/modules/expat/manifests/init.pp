
class expat {

	$expat = $operatingsystem ? {
			centos => 'expat',
			redhat => 'expat',
			debian => 'expat',
			ubuntu => 'expat',
			default => undef,
		}

	$expatdevel = $operatingsystem ? {
			centos => 'expat-devel',
			redhat => 'expat-devel',
			debian => 'libexpat-dev',
			ubuntu => 'libexpat-dev',
			default => undef,
		}

	package { $expat:
		ensure => installed,
		alias => expat,
	}

	package { $expatdevel:
		ensure => installed,
		alias => expat-devel,
	}

}

