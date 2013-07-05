
define projects-fs ($production = undef) {

	if $production {
		nfs-mount { "/projects/$title":
			source => "nfs.nci.org.au:/cxfs/projects/$title",
			root_squash => $title,
			require => Class["ldap::client"],
		}
	} else {
		exec { "create /projects/$title":
			command => "/bin/mkdir -p /projects/$title",
			creates => "/projects/$title",
		}

		file { "/projects":
			ensure => directory,
			mode => 0755,
			owner => root,
			group => root,
			require => Exec["create /projects/$title"],
		}
		file { "/projects/$title":
			ensure => directory,
			mode => 0770,
			owner => root,
			group => "$title",
			require => Exec["create /projects/$title"],
		}
	}

}

