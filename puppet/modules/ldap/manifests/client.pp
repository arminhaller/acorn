
class ldap::client {

	case $osfamily {
		RedHat: {
			# Fine.
		}
		default: {
			fail("ldap::client not yet supported on non-RedHat systems")
		}
	}

	package { ['openldap', 'pam_ldap', 'openssl-perl', ]:
		ensure => present,
	}

	class { 'nsswitch':
		module_type => 'ldap',
		uri => 'ldaps://sfldap0.anu.edu.au/',
		base => 'dc=apac,dc=edu,dc=au',
	}

	file_line { '/etc/nslcd.conf/ssl':
		path => '/etc/nslcd.conf',
		line => 'ssl no',
		match => '^ssl ',
		require => Class['nsswitch'],
		notify => Service[$nsswitch::params::service],
	}

	file_line { '/etc/nslcd.conf/tls_cacertdir':
		path => '/etc/nslcd.conf',
		line => 'tls_cacertdir /etc/openldap/certs',
		match => '^tls_cacertdir ',
		require => Class['nsswitch'],
		notify => Service[$nsswitch::params::service],
	}

	file { '/etc/openldap/ldap.conf':
		ensure => present,
		source => "puppet:///modules/ldap/client/openldap/ldap.conf",
		owner => root,
		group => root,
		mode => '0644',
		require => Package['openldap'],
		notify => Service[$nsswitch::params::service],
	}

	file { '/etc/pam_ldap.conf':
		ensure => present,
		source => "puppet:///modules/ldap/client/pam_ldap.conf",
		owner => root,
		group => root,
		mode => '0644',
		require => Package['pam_ldap'],
		notify => Service[$nsswitch::params::service],
	}

	file { '/etc/nslcd.conf':
		ensure => present,
		owner => root,
		group => root,
		mode => '0600',
		require => Class['nsswitch'],
		notify => Service[$nsswitch::params::service],
	}

	file { '/etc/openldap/certs/apac_nf_ca.pem':
		ensure => present,
		source => "puppet:///modules/ldap/client/openldap/certs/apac_nf_ca.pem",
	}

	exec { '/usr/bin/c_rehash /etc/openldap/certs':
		require => [ File['/etc/openldap/certs/apac_nf_ca.pem'], Package['openssl-perl'], ],
	}

	include nfsh

	include authconfig

	exec { "enable_pam_ldap":
		command => "/usr/sbin/authconfig --enableldapauth --update",
		unless  => "/usr/sbin/authconfig --test | grep -q 'pam_ldap is enabled'",
		require => [ Package[authconfig, pam_ldap], ],
	}

	exec { "enable_pam_mkhomedir":
		command => "/usr/sbin/authconfig --enablemkhomedir --update",
		unless  => "/usr/sbin/authconfig --test | grep -q 'pam_mkhomedir or pam_oddjob_mkhomedir is enabled'",
		require => [ Package[authconfig, pam_ldap], ],
	}

}

