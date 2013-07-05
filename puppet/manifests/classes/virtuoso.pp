
class virtuoso {


#---------------------------------------------------------------------------#
#                             VARIABLES
#---------------------------------------------------------------------------#

#virtuoso version to download and install
$VERSION="6.1.6"

#base puppet directory
$PUPPETDIR="/puppet"

#---------------------------------------------------------------------------#


#path for executables (needed for sudo usage)
Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin' }


#install system packages
notify { "Installing system packages if necessary": }
package { "gcc": 
        ensure => installed 
    }

package { "autoconf": 
        ensure => installed,
        require => Package["gcc"],
    }

package { "automake": 
        ensure => installed,
        require => Package["autoconf"],
    }

package { "libtool": 
        ensure => installed,
        require => Package["automake"],
 
    }

package { "flex": 
        ensure => installed,
        require => Package["libtool"],
 
    }

package { "bison": 
        ensure => installed,
        require => Package["flex"],

    }

package { "gawk": 
        ensure => installed,
        require => Package["bison"],
    }

package { "m4": 
        ensure => installed,
        require => Package["gawk"],
    }

package { "make": 
        ensure => installed,
        require => Package["m4"],
    }

package { "openssl-devel": 
        ensure => installed ,
        require => Package["make"],
    }

package { "readline-devel": 
        ensure => installed,
        require => Package["openssl-devel"],
    }

package { "wget": 
        ensure => installed,
        require => Package["readline-devel"], 
    }



#download virtuoso source if not present
notify { "Downloading source if necessary": }
exec{"download_source":
    command => "wget http://downloads.sourceforge.net/project/virtuoso/virtuoso/$VERSION/virtuoso-opensource-$VERSION.tar.gz -O $PUPPETDIR/temp/virtuoso-opensource-$VERSION.tar.gz",
    creates => "$PUPPETDIR/temp/virtuoso-opensource-$VERSION.tar.gz",
    timeout => 0,
    require => Package["wget"],
}



#extract source 
notify { "Extracting source if necessary": }
exec { "extract_source":
  command => "tar -xvpf $PUPPETDIR/temp/virtuoso-opensource-$VERSION.tar.gz",
  cwd     => "$PUPPETDIR/temp",
  creates => "$PUPPETDIR/temp/virtuoso-opensource-$VERSION",
  require => Exec["download_source"],
}

#configure
notify { "Configuring virtuoso if necessary": }
exec { "configure_virtuoso":
  command => "$PUPPETDIR/temp/virtuoso-opensource-$VERSION/configure --prefix=/usr/local --with-readline",
  cwd     => "$PUPPETDIR/temp/virtuoso-opensource-$VERSION",
  creates => "$PUPPETDIR/temp/virtuoso-opensource-$VERSION/Makefile",
  require => Exec["extract_source"],
  timeout => 0;
}

#make
notify { "Making virtuoso if necessary": }
exec { "make_virtuoso":
  command => "make",
  cwd     => "$PUPPETDIR/temp/virtuoso-opensource-$VERSION",
  require => Exec["configure_virtuoso"], 
  timeout => 0;
}

#make install
notify { "Installing virtuoso if necessary": }
exec { "install_virtuoso":
  command => "make install",
  cwd     => "$PUPPETDIR/temp/virtuoso-opensource-$VERSION",
  require => Exec["make_virtuoso"], 
  timeout => 0;
}

#add a user to run virtuoso
#note, to generate a new password hash, create a user manually (useradd virtuoso; passwd virtuoso) then look in /etc/shadow for password hash
notify { "Creating virtuoso user if necessary": }
user { 'virtuoso':
  ensure => 'present',
  home   => '/home/virtuoso',
  shell  => '/bin/bash',
  uid    => '500',
  password => "$6$Sw2imCP6$VifhGQGMzcoUg.TbwZQLN3dhw7LKqrZRlBFgkDPTPLhi99C2njpR37Icxh87Eyea5KT/tPkYhNaet0avfPbjC.:15799:0:99999:7:::",
  require => Exec["install_virtuoso"], 
}

#update URIs with python script
#notify {"updating URIs":}
#exec{"updatingURIs":
#    command =>"python setUpVirtuoso.py",
#    cwd => "$PUPPETDIR/data/",
#    require => User["virtuoso"],
#            }





#start virtuoso server
notify { "Starting virtuoso": }
exec { "start_virtuoso":
  command => "virtuoso-t -d",
  cwd     => "/usr/local/var/lib/virtuoso/db",
 # require => Exec["updatingURIs"], 
 require => User["virtuoso"],
} 

#Ichange dba password to dbanew
#file {"changepIw.sql":
# path => "$PUPPETDIR/temp/changepw.sql",
# ensure => present,
# mode => 0640,
# content => "set password dba dbanew;",
#}


#this is better done out of band
#notify { "changing passwords": }
#exec { "change_passwords":
#  command => "isql 1111 dba dba $PUPPETDIR/temp/changepw.sql",
#  cwd     => "/usr/local/var/lib/virtuoso/db",
#  require => Exec["start_virtuoso"], 
#} 

notify {"bulk upload ontology 1":}
exec{"bulk_upload":
    command => "isql 1111 dba dba exec=\"ld_dir('$PUPPETDIR/data/rdf/ontology','*.rdf','http://localhost:8890/DAV')\";" ,
    require => Exec["start_virtuoso"],
}




notify {"bulk upload ontology 2":}
exec{"bulk_upload2":
    command => "isql 1111 dba dba exec=\"ld_dir('$PUPPETDIR/data/rdf/ontology','*.owl','http://localhost:8890/DAV')\";" ,
    require => Exec["bulk_upload"],
}



notify {"bulk upload obs":}
exec{"bulk_upload3":
    command => "isql 1111 dba dba exec=\"ld_dir('$PUPPETDIR/data/rdf/observations','*.xml','http://localhost:8890/DAV')\";" ,
    require => Exec["bulk_upload2"],
}

notify {"run uploader":}
exec{"run_uploader":
    command => "isql 1111 dba dba exec=\"rdf_loader_run();\"",
    require => Exec["bulk_upload3"],
}

#end of class virtuoso
} 

