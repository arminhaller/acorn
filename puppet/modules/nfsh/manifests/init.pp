
class nfsh {

	include nfnewgrp

	file { '/opt/bin/nfsh':
		ensure => present,
		source => "puppet:///modules/nfsh/nfsh",
		mode => 0755,
		owner => root,
		group => root,
	}

	file { '/opt/bin/kshenv':
		ensure => present,
		source => "puppet:///modules/nfsh/kshenv",
		mode => 0644,
		owner => root,
		group => root,
	}

	file { '/opt/bin/bashenv':
		ensure => present,
		source => "puppet:///modules/nfsh/bashenv",
		mode => 0644,
		owner => root,
		group => root,
	}

}
