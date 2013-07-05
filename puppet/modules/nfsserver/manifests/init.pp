# Class: nfsserver
#
# Setup an NFS server
#
class nfsserver {

    # Don't know why this doesn't work.
    # Have to do it from inside the node instead.
    if ! defined_with_params(Class[idmapd]) {
        class { "idmapd": }
    }

    case $operatingsystem {
        "Ubuntu", "Debian": {
            # FIXME
            $packages = [ "nfs-client", "portmap" ]
            $services = [ "portmap", "statd" ]
        }
        "RedHat", "CentOS": {
          if ($operatingsystemrelease =~ /[1-5]\./) {
            $packages = [ "nfs-utils", "portmap" ]
            #$services = [ "nfsd", "rpc.mountd", "rpc.rquotad", "rpc.statd" ]
            $services = [ "nfs", "nfslock", ]
          }
          else {
            $packages = [ "nfs-utils", "rpcbind" ]
            #$services = [ "nfsd", "rpc.mountd", "rpc.rquotad", "rpc.statd" ]
            $services = [ "nfs", "nfslock", ]
          }
        }
        default: {
            fail("Unable to configure NFS server for $operatingsystem systems.")
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

} # class nfsserver
