
define bind-mount ($source, $mountpoint = $title, $root_squash = undef, $owner = "") {

	exec { "create $mountpoint":
		command => "/bin/mkdir -p $mountpoint",
		creates => $mountpoint,
	}

	mount { "$mountpoint":
		ensure => mounted,
		device => "$source",
		require => [ Exec["create $mountpoint"], Exec["create $source"], ],
		fstype => "none",
		options => "bind",
	}

	if $root_squash {
		squashed-mount { "$mountpoint":
			root_squash => "$root_squash",
		}
		# Permissions...?
		$create_source_prefix = "/sbin/setuid $owner.$root_squash "
	} else {
		$create_source_prefix = ""
	}

	exec { "create $source parent":
		command => "${create_source_prefix}/bin/mkdir -p `dirname $source`",
		unless => "${create_source_prefix}/usr/bin/test -d `dirname $source`",
	}

	if $root_squash {
		exec { "fix perms $source parent":
			command => "${create_source_prefix}/bin/chmod 2771 `dirname $source`",
			unless => "/bin/bash -c '/usr/bin/test `${create_source_prefix}/usr/bin/stat -c %a \$(dirname $source)` = 2771'",
			require => Exec["create $source parent"],
			before => Exec["create $source"],
		}
	}

	exec { "create $source":
		command => "${create_source_prefix}/bin/mkdir -p $source",
		unless => "${create_source_prefix}/usr/bin/test -d $source",
		require => [ Exec["create $source parent"], ],
	}

}

