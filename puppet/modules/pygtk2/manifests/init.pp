
class pygtk2 {
	include python

	$pygtk2 = $operatingsystem ? {
			centos => 'pygtk2',
			redhat => 'pygtk2',
			debian => 'python-gtk2',
			ubuntu => 'python-gtk2',
			default => undef,
		}

	$pygtk2devel = $operatingsystem ? {
			centos => 'pygtk2-devel',
			redhat => 'pygtk2-devel',
			debian => 'python-gtk2-dev',
			ubuntu => 'python-gtk2-dev',
			default => undef,
		}

	package { $pygtk2:
		ensure => installed,
		alias => pygtk2,
	}

	package { $pygtk2devel:
		ensure => installed,
		alias => pygtk2-devel,
	}

}

