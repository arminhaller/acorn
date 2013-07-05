define ssh::host_keys {
	# Still a bit too much repetition here...
	file {
	"/etc/ssh/ssh_host${title}key.pub":
		ensure => present,
		source => [
		    "puppet:///modules/ssh/hostkeys/$fqdn/ssh_host${title}key.pub",
		    "puppet:///modules/ssh/hostkeys/$hostname/ssh_host${title}key.pub",
		    "puppet:///modules/ssh/hostkeys/ssh_host${title}key.pub",
		],
		mode => 0644,
		owner => 'root',
		group => 'root',
		require => Package['openssh-server'],
		notify => Service["$ssh::ssh_service"],
	;
	"/etc/ssh/ssh_host${title}key":
		ensure => present,
		source => [
		    "puppet:///modules/ssh/hostkeys/$fqdn/ssh_host${title}key",
		    "puppet:///modules/ssh/hostkeys/$hostname/ssh_host${title}key",
		    "puppet:///modules/ssh/hostkeys/ssh_host${title}key",
		],
		mode => 0600,
		owner => 'root',
		group => 'root',
		require => Package['openssh-server'],
		notify => Service["$ssh::ssh_service"],
	}
}

