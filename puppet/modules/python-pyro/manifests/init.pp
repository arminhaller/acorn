
class python-pyro {
	include python

	case $operatingsystem {
		centos, redhat: {
			# The python-pyro package lives in EPEL.
			include epel
			package { 'python-pyro':
				ensure => installed,
			}
		}
		debian, ubuntu: {
			package { 'pyro':
				ensure => installed,
				alias => python-pyro,
			}
		}
		default: {
			fail("Unrecognized operating system for python-pyro")
		}
	}

}

