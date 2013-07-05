
define profile_d::prepend-path($var = 'PATH', $path) {
	include profile_d

	profile_d::script { "${name}.sh":
		ensure => present,
		content => "$var='$path'\"\${$var:+:}\$$var\"\nexport $var\n",
	}

	profile_d::script { "${name}.csh":
		ensure => present,
		content => "if ( \$?$var ) then\n    setenv $var $path:\$$var\nelse\n    setenv $var $path\nendif\n",
	}

}

