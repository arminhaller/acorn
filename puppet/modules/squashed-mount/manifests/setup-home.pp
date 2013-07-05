
class squashed-mount::setup-home {

	exec { "preserve_real_mkhomedir_helper":
		creates => "/sbin/mkhomedir_helper.real",
		command => "/bin/mv /sbin/mkhomedir_helper /sbin/mkhomedir_helper.real",
		refresh => "/bin/true",
	}

	file { "/sbin/mkhomedir_helper":
		source => "puppet:///modules/squashed-mount/mkhomedir_helper",
		owner => root,
		group => root,
		mode => '0755',
		require => [ Exec['preserve_real_mkhomedir_helper'], Class['setuid'], ],
	}

}

