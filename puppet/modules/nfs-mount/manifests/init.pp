
define nfs-mount ($source, $mountpoint = $title, $root_squash = undef) {

	exec { "create $mountpoint":
		command => "/bin/mkdir -p $mountpoint",
		creates => $mountpoint,
	}

	include nfsclient
	mount { "$mountpoint":
		ensure => mounted,
		device => "$source",
		require => [ Exec["create $mountpoint"], Class["nfsclient"], ],
		fstype => "nfs",
		options => "rw",
	}

	if $root_squash {
		squashed-mount { "$mountpoint":
			root_squash => "$root_squash",
		}
	}

}

