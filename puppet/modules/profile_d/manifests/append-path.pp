
define profile_d::append-path($var = 'PATH', $path) {
	include profile_d

	profile_d::script { "${name}.sh":
		ensure => present,
		content => "$var=\"\$$var\${$var:+:}\"'$path'\nexport $var\n",
	}

	profile_d::script { "${name}.csh":
		ensure => present,
		content => "if ( \$?$var ) then\n    setenv $var \$$var:$path\nelse\n    setenv $var $path\nendif\n",
	}

}

