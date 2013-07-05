
class elda {


#---------------------------------------------------------------------------#
#                             VARIABLES
#---------------------------------------------------------------------------#

#ELDA Version
$VERSION="1.2.21"

#base puppet directory
$PUPPETDIR="/puppet"

#---------------------------------------------------------------#

#path for executables (needed for sudo usage)
Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin' }


#install system packages
notify { "Installing system packages if necessary": }

package { "httpd":
        ensure => installed
    }

package { "tomcat6":
        ensure => installed
    }


package { "tomcat6-webapps":
        ensure => installed
    }

package { "tomcat6-admin-webapps":
        ensure => installed
    }
package { "wget":
        ensure => installed
    }


file {
    "/www":
    ensure => "directory",
    owner => "tomcat",
    group => "tomcat",
    mode => 750,
    require => Package['httpd','tomcat6','tomcat6-webapps','tomcat6-admin-webapps','wget'], }


#download java
notify {"downloading java":}
exec {"download_java":
    command => "wget http://javadl.sun.com/webapps/download/AutoDL?BundleId=76852 -O jre-7u21-linux-x64.rpm",
    creates => "$PUPPETDIR/temp/jre-7u21-linux-x64.rpm",
    timeout => 0,
    require => File["/www"],
}

#install java
notify {"installing java":}
exec {"install_java":
    command => "rpm -i jre-7u21-linux-x64.rpm",
    cwd => "$PUPPETDIR/temp",
    creates => "/usr/bin/java",
    require => Exec["download_java"],
}



#download elda source if not present
notify { "Downloading elda source if necessary": }
exec {"download_source":
              command => "wget http://elda.googlecode.com/files/elda-standalone-$VERSION.jar -O /www/elda-standalone-$VERSION.jar",
              creates => "/www/elda-standalone-$VERSION.jar",
              timeout => 0,
              require => Exec[ "install_java" ],
      }


#set right java path
notify {"configuring system java":}
exec {"set_java":
    command => "update-alternatives --install /usr/bin/java java /usr/java/jre1.7.0_21/bin/java 0;update-alternatives --set java /usr/java/jre1.7.0_21/bin/java",
    require => Exec["download_source"],
 }


#extract source 
notify { "Extracting source if necessary": }
exec {"extract_source":
  command => "unzip elda-standalone-1.2.21.jar -d elda-standalone-1.2.21",
  cwd     => "/www",
  creates => "/www/elda-standalone-$VERSION",
  timeout => 0,
  require => Exec["set_java"],
}

#copy elda webapps to tomcat 
#notify {"copying elda to tomcat":}
#exec { "copying_elda": 
#    command => "cp -r /www/elda_standalone_$VERSION/webapps/elda/ /usr/share/tomcat6/webapps/",
#    timeout => 0,    
#    require => Exec["extract_source"],
#}

#create symlink from tomcat to elda webapp
notify {"creating symlink to elda webapp":}
file { "/usr/share/tomcat6/webapps/elda":
   ensure => "link",
   target => "/www/elda-standalone-${VERSION}/webapps/elda/",
   require => Exec["extract_source"],
}


#update URIs with python script
#notify {"updating URIs":}
#exec{"updatingURIs":
#    command =>"python setUpElda.py",  
#    cwd => "$PUPPETDIR/data/",
#    require => File["/usr/share/tomcat6/webapps/elda"],
#}


#copy elda acornsat config to tomcat
notify {"copying acornsat config to tomcat":}
exec {"copying_acornsat_config":
   command => "cp $PUPPETDIR/data/acorn.ttl /usr/share/tomcat6/webapps/elda/specs/acorn.ttl",
 #  require => Exec["updatingURIs"],
 require => File["/usr/share/tomcat6/webapps/elda"],
}

#copy elda web.xml to tomcat
notify {"copying web.xml config to tomcat":}
exec {"copying_webxml_onfig":
   command => "cp $PUPPETDIR/data/web.xml /usr/share/tomcat6/webapps/elda/WEB-INF/web.xml",
require => Exec["copying_acornsat_config"],

}


#end of class elda
} 

