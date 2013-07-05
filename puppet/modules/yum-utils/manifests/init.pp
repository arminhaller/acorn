
class yum-utils {

	case $operatingsystem {
		"RedHat", "CentOS": {
			package { 'yum-utils':
				ensure => present,
			}
		}
	}

}
