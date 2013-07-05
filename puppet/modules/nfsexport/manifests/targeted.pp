
define nfsexport::targeted ($machine = $title, $ip = undef, $path, $base = "/data/exports") {

	if $ip {
		$my_ip = $ip
	} else {
		$my_ip = $machine
	}

	if ! defined_with_params(File["$base/$machine"]) {
		file { "$base/$machine":
			ensure => directory,
			owner => root,
			group => root,
			# Not sure why 0700 causes permission problems when mounting...
			mode => 0711,
			# This must have been setup elsewhere.
			require => [ File[$base], ],
		}
	}

	if is_array($path) {
		$export = prefix($path, "$base/$machine/")
	} else {
		$export = "$base/$machine/$path"
	}
	file { $export:
		ensure => directory,
		owner => root,
		group => root,
		mode => 0700,
		require => [ File["$base/$machine"], ],
	}

	nfsexport { $export:
		clients => "$my_ip(rw,no_subtree_check,no_root_squash,secure)",
		require => [ File[$export], ],
	}

}

