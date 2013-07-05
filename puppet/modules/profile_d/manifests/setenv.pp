
define profile_d::setenv($var, $value) {
	include profile_d

	profile_d::script { "${name}.sh":
		ensure => present,
		content => "$var='$value'\nexport $var\n",
	}

	profile_d::script { "${name}.csh":
		ensure => present,
		content => "setenv $var '$value'\n",
	}

}

