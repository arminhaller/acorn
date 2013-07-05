
class python-cherrypy {
	include python

	case $operatingsystem {
		centos, redhat: {
			# There is no package for python-cherrypy 3.x.
			package { 'cherrypy':
				ensure => installed,
				provider => pip,
				alias => python-cherrypy,
				require => File['/usr/bin/pip'],
			}
		}
		debian, ubuntu: {
			package { 'python-cherrypy3':
				ensure => installed,
				alias => python-cherrypy,
			}
		}
		default: {
			fail("Unrecognized operating system for python-cherrypy")
		}
	}

}

