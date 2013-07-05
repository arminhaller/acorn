
class setuid {

	include python
	file { '/sbin/setuid':
		ensure => present,
		source => "puppet:///modules/setuid/setuid",
		owner => 'root',
		group => 'root',
		mode => 0755,
		require => Package['python'],
	}

}
