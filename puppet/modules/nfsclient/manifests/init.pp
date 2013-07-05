# Class: nfsclient
#
# Setup an NFS client
#
class nfsclient {

    # Don't know why this doesn't work.
    # Have to do it from inside the node instead.
    if ! defined_with_params(Class[idmapd]) {
        class { "idmapd": }
    }

    case $operatingsystem {
        "Ubuntu", "Debian": {
            $packages = [ "nfs-client", "portmap" ]
            $services = [ "portmap", "statd" ]
            Service[portmap] -> Service[statd]
        }
        "RedHat", "CentOS": {
          if ($operatingsystemrelease =~ /[1-5]\./) {
            $packages = [ "nfs-utils", "portmap" ]
            $services = [ "nfslock", "portmap" ]
            Service[portmap] -> Service[nfslock]
          }
          else {
            $packages = [ "nfs-utils", "rpcbind" ]
            $services = [ "nfslock", "rpcbind" ]
            Service[rpcbind] -> Service[nfslock]
          }
        }
        default: {
            fail("Unable to configure NFS client for $operatingsystem systems.")
        }
    }

    Package {
        ensure => present
    }

    package {
        $packages:;
    } # package

    Service {
        enable  => true,
        ensure  => running,
        require => [ Package[$packages], Service[rpcidmapd], ],
    }

    service {
        $services:;
    } # service

} # class nfsclient
