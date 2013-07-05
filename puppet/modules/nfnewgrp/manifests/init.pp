
class nfnewgrp {

	file { '/opt/bin/nfnewgrp':
		ensure => present,
		source => "puppet:///modules/nfnewgrp/nfnewgrp",
		mode => 04755,
		owner => root,
		group => root,
	}

}
