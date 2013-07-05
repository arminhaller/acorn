
class pygraphviz {
	include python
	include gcc

	case $operatingsystem {
		centos, redhat: {
			# No system pygraphviz package, use pip.
			package { [ 'graphviz', 'graphviz-devel', 'pkgconfig']:
				ensure => installed,
			}
			package { 'pygraphviz':
				ensure => installed,
				provider => pip,
				require => [ File['/usr/bin/pip'], Package['graphviz','graphviz-devel', 'gcc', 'pkgconfig'], ],
			}
		}
		debian, ubuntu: {
			package { 'python-pygraphviz':
				ensure => installed,
				alias => 'pygraphviz',
			}
		}
		default: {
			notify("Unrecognized operating system for pygraphviz")
			package { [ 'graphviz', 'graphviz-devel', 'pkg-config']:
				ensure => installed,
			}
			package { 'pygraphviz':
				ensure => installed,
				provider => pip,
				require => [ File['/usr/bin/pip'], Package['graphviz','graphviz-devel', 'gcc', 'pkg-config'], ],
			}
		}
	}

}

