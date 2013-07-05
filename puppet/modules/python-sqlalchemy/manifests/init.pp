
class python-sqlalchemy {
	include python

        case $operatingsystem {
                centos, redhat: {
                        package { 'SQLAlchemy':
                                ensure => installed,
                                provider => pip,
                                alias => python-sqlalchemy,
                                require => File['/usr/bin/pip'],
                        }
                }
                debian, ubuntu: {
                        package { 'python-sqlalchemy':
                                ensure => installed,
                                alias => python-sqlalchemy,
                        }
                }
                default: {
                        fail("Unrecognized operating system for python-sqlalchemy")
                }
        }


}

