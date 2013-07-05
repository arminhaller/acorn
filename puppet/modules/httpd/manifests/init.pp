
class httpd ($document_root = "/var/www/html", $document_root_group = "apache") { 
	package { "httpd":
		ensure => present,
	}
	service { "httpd":
		ensure => running,
		enable => true,
		require => Package["httpd"],
	}
	file { $document_root:
		ensure => directory,
		group => $document_root_group,
		# kjp900: The leading '2' here sets the "group sticky bit",
		# which ensures that all files/dirs created underneath get
		# the same group owner (by default), which can be useful
		# in situations like this.
		mode => 02664,
		before => Service["httpd"],
	}

        file_line { "httpd_conf_document_root":
                path => "/etc/httpd/conf/httpd.conf",
                line => "DocumentRoot \"$document_root\"",
                match => "^DocumentRoot \".*\"$",
                notify => Service["httpd"],
        }

        file_line { "httpd_conf_document_root_access":
                path => "/etc/httpd/conf/httpd.conf",
                line => "<Directory \"$document_root\">",
                match => "^<Directory \"($document_root|/var/www/html)\">$",
                notify => Service["httpd"],
        }

}

