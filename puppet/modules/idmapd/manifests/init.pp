
class idmapd ($domain = "nci.org.au") {

    service { "rpcidmapd":
        enable  => true,
        ensure => running,
    }

    file_line { "idmapd domain":
        path => "/etc/idmapd.conf",
        match => "^#?Domain[ 	][ 	]*=[ 	]",
        line => "Domain = $domain",
        notify => Service["rpcidmapd"],
    }

}
