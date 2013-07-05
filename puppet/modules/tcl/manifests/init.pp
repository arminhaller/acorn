class tcl {
	package { [ 'tcl', 'tcl-devel', 'tclx', 'tclx-devel', ]:
		ensure => present,
	}
}
