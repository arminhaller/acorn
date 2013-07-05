
class squashed-mount::setup {

	file { '/etc/squashed_mounts':
		ensure => present,
		owner => root,
		group => root,
		mode => '0644',
	}

	file { "/usr/local/sbin/mount":
		source => "puppet:///modules/squashed-mount/mount",
		owner => root,
		group => root,
		mode => '0755',
		require => Class['setuid'],
	}

}

