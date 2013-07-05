
define profile_d::script($ensure = 'present', $content = undef, $source = undef, $base = undef) {

	include profile_d

	if ! $content and ! $source {
		if $base {
			$my_base = $base
		} else {
			$my_base = "/puppet/files/etc/profile.d"
		}
		$my_source = "$my_base/$name"
	} else {
		$my_source = $source
	}

	file {"/etc/profile.d/${name}":
		ensure => $ensure,
		owner => root,
		group => root,
		mode => '0644',
		content => $content,
		source => $my_source,
		require => File['/etc/profile.d'],
	}

}

