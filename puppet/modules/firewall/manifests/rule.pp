
# FIXME later: ability to specify source host(s)
define firewall::rule ($proto = tcp, $port, $result = "ACCEPT") {

	file_line { "/etc/sysconfig/iptables $proto $port $result":
		path => "/etc/sysconfig/iptables",
		match => "^-A RH-Firewall-1-INPUT -m state --state NEW -m $proto -p $proto --dport $port -j ",
		line => "-A RH-Firewall-1-INPUT -m state --state NEW -m $proto -p $proto --dport $port -j $result",
		notify => Service[iptables],
		require => File_line["/etc/sysconfig/iptables pre rules"],
		before => File_line["/etc/sysconfig/iptables footer rules"],
	}

}

