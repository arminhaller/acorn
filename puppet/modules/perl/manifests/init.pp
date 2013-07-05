
class perl {

	package { 'perl':
		ensure => present,
	}

	case $operatingsystem {
		centos, redhat: {
			# Here we also need the perl-CPAN package.
			package { 'perl-CPAN':
				ensure => installed,
			}
			$perl_cpan = "perl-CPAN"
		}
		default: {
			$perl_cpan = "perl"
		}
	}

	file { '/usr/share/perl5/CPAN/Config.pm':
		ensure => present,
		source => "puppet:///modules/perl/Config.pm",
		require => Package[$perl_cpan],
	}

	# A stupid wrapper that will do a no-op on "make test" if
	# the $SKIP_TESTS environment variable is set to y.
	file { "/usr/local/bin/make":
		ensure => present,
		source => "puppet:///modules/perl/skip-tests-bin/make",
		mode => '0755',
	}
}

