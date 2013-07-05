
class firewall {

	# This is for Centos, no idea about Ubuntu yet.

	package { iptables:
		ensure => present,
	}

	service { iptables:
		ensure => running,
		require => Package[iptables],
	}

	file_line { "/etc/sysconfig/iptables pre rules":
		path => "/etc/sysconfig/iptables",
		line => "COMMIT",
		ensure => absent,
		require => File_line["/etc/sysconfig/iptables pre rule 1"],
	}

	file_line { "/etc/sysconfig/iptables pre rule 1":
		path => "/etc/sysconfig/iptables",
		line => "-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited",
		ensure => absent,
	}

	file_line { "/etc/sysconfig/iptables footer rules":
		path => "/etc/sysconfig/iptables",
		line => "-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited",
		notify => Service[iptables],
	}

	file_line { "/etc/sysconfig/iptables footer rule 1":
		path => "/etc/sysconfig/iptables",
		line => "COMMIT",
		notify => Service[iptables],
		require => File_line["/etc/sysconfig/iptables footer rules"],
	}

}
