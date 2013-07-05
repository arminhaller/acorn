
class motd {
	file { "/etc/motd":
		ensure => present,
		source => [
		    "puppet:///modules/motd/$fqdn/motd",
		    "puppet:///modules/motd/$hostname/motd",
		    "puppet:///modules/motd/motd",
		],
		mode => 0644,
		owner => root,
		group => root,
	}
}
