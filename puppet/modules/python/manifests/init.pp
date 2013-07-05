
class python {

	case $operatingsystem {
		centos, redhat: {
			# The python-pip package lives in EPEL.
			include epel
			package { ['python', 'python-devel', 'python-pip']:
				ensure => installed,
			}
			file { '/usr/bin/pip':
				ensure => link,
				target => '/usr/bin/pip-python',
				require => Package['python-pip'],
			}
		}
		debian, ubuntu: {
			package { ['python', 'python-pip']:
				ensure => installed,
			}
			# Ensure we stick to EL package naming conventions.
			package { 'python-dev':
				ensure => installed,
				alias => python-devel,
			}
			file { '/usr/bin/pip':
				ensure => present,
				require => Package['python-pip'],
			}
		}
		default: {
			notify("Unrecognized operating system for python")
			package { 'python':
				ensure => installed,
			}
			# FIXME: manually install pip (ala Slackware)
		}
	}

}

