# Class: nfsexport
#
# Setup an NFS export
#
define nfsexport ($localpath = $title, $clients) {

	file_line { "nfsexport $localpath $clients":
		path => "/etc/exports",
		match => "^$localpath[ 	]",
		line => "$localpath        $clients",
		notify => Service[$nfsserver::services],
	}

} # class nfsexport
