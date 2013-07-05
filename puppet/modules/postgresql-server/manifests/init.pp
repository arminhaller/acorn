
class postgresql-server {

	package { [ 'postgresql-server', ]:
		ensure => present,
	}

}
