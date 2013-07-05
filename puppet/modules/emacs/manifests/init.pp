
class emacs {
	include ssh::x11_forwarding	

	package { [ 'emacs', ]:
		ensure => installed,
	}

	package { [ 'xorg-x11-fonts-Type1', 'dejavu-sans-mono-fonts', ]:
		ensure => installed,
		require => [ Package[xauth], ],
	}

	file { "/root/.emacs":
		ensure => present,
		content => "(custom-set-variables \'(inhibit-startup-screen t))\n( set-default-font \"-unknown-DejaVu Sans Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1\" )",
	}

}
