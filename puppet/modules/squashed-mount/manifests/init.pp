
define squashed-mount ($mountpoint = $title, $root_squash = undef) {

	include squashed-mount::setup

	# Deal with the perculiarities of root_squash.
	include setuid

	file_line { "/etc/squashed_mounts/$mountpoint":
		path => '/etc/squashed_mounts',
		line => "$mountpoint $root_squash",
		notify => [ Mount["$mountpoint"], ],
		require => [ File["/usr/local/sbin/mount"], ],
	}

	if $mountpoint == "/home" {
		include squashed-mount::setup-home
	}

}

