
class pam_access ($allowed = undef, $denied = undef, $default = "deny") {

	case $osfamily {
		RedHat: {
			# Fine.
		}
		default: {
			fail("pam_access not yet supported on non-RedHat systems")
		}
	}

	include authconfig

	exec { "enable_pam_access":
		command => "/usr/sbin/authconfig --enablepamaccess --update",
		unless  => "/usr/sbin/authconfig --test | grep -q 'pam_access is enabled'",
		require => [ Package[authconfig], ],
	}

	file_line { '/etc/pam.d/system-auth/pam_access/nodefgroup':
		path => '/etc/pam.d/system-auth',
		line => "account     required      pam_access.so nodefgroup",
		match => '^account     required      pam_access.so( nodefgroup)?$',
		require => Exec['enable_pam_access'],
	}

	file_line { '/etc/pam.d/password-auth/pam_access/nodefgroup':
		path => '/etc/pam.d/password-auth',
		line => "account     required      pam_access.so nodefgroup",
		match => '^account     required      pam_access.so( nodefgroup)?$',
		require => Exec['enable_pam_access'],
	}

	file { '/etc/security/access.conf':
		ensure => present,
		content => template("pam_access/access.conf.erb"),
		owner => root,
		group => root,
		mode => '0644',
	}

}

