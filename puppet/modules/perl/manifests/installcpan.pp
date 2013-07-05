
# Courtesy of http://www.mail-archive.com/puppet-users@googlegroups.com/msg24827.html

define perl::installCPAN ($skip_tests = false, $extra_args = '') {
	include perl
	if ($skip_tests == true) {
		$env = [ 'SKIP_TESTS=y', ]
	} else {
		$env = []
	}
	exec { "cpan_install_$name":
		command => "/usr/bin/cpan -i \"$name\" ${extra_args}",
		environment => $env,
		timeout => 600,
		unless  => "/usr/bin/perl -e \"use $name\"",
		require => [ Package[$perl::perl_cpan], File['/usr/local/bin/make'], ],
	}
}

